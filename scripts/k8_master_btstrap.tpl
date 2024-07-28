#!/bin/bash

# Define named pipe variable
signal="${MOUNT_POINT}/proceed_signal"

sudo apt-get update 
sudo apt-get install nfs-common -y
sudo snap install aws-cli --classic
sudo apt install mysql-server -y
sudo apt install mysql-client -y


mkdir -p /home/ubuntu/monitoring

# Restart container services
sudo systemctl restart containerd.service
sudo systemctl restart docker.service


sudo echo 'alias init="sudo tail -40f /var/log/cloud-init-output.log"' >> /home/ubuntu/.bashrc

source ~/.bashrc

#installing helm and loading the prometheus repo
snap install helm --classic 
mkdir -p /home/ubuntu/.cache/helm
sudo chown -R ubuntu.ubuntu /home/ubuntu/.cache/helm

whoami > /home/ubuntu/wtfami.txt
cd /home/ubuntu

# Disabling swap
sudo swapoff -a
echo "swap turned off" > /home/ubuntu/startup.log

# Getting the server's private IP address
PRIVATE_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "$${PRIVATE_IP}" >> /home/ubuntu/startup.log


# Define the mount options in a variable
MOUNT_OPTIONS="nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev"

# Making mount point directory if it doesnt exist already
sudo mkdir -p "${MOUNT_POINT}"

# Adding /etc/fstab if not already present
if ! grep -q "${EFS_DNS}:/ ${MOUNT_POINT} nfs4" /etc/fstab; then
  echo "${EFS_DNS}:/ ${MOUNT_POINT} nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
fi

# Mounting EFS and mount options until its done successfully
while true; do
  if sudo mount -t nfs4 -o "$${MOUNT_OPTIONS}" "${EFS_DNS}":/ "${MOUNT_POINT}"; then
    echo "NFS mounted successfully."
    break
  else
    echo "Failed to mount NFS, retrying in 10 seconds..."
    sleep 5
  fi
done

# Ensuring all filesystems from fstab are mounted
sudo mount -a -t nfs4

sudo chown ubuntu "${MOUNT_POINT}"

# Setting hostname
sudo hostnamectl set-hostname k8s-master
hostname > /home/ubuntu/startup.log

# Managing /etc/hosts file
HOSTS_FILE="${MOUNT_POINT}/hosts_list.txt"
if [ -f "$${HOSTS_FILE}" ]; then
    sudo sed -i "/ k8s-master$/d" "$${HOSTS_FILE}"
else
    touch "$${HOSTS_FILE}"
fi
echo "$${PRIVATE_IP} k8s-master" >> "$${HOSTS_FILE}"

# Ensuring the /etc/hosts file has 3 lines
while [ "$(wc -l < "$${HOSTS_FILE}")" -ne 3 ]; do
    sleep 20
done

# Updating /etc/hosts
sudo tee -a /etc/hosts < "$${HOSTS_FILE}"

# Creating a watcher script any /etc/hosts updates

cat << 'EOF' > /home/ubuntu/hosts_watcher.sh
#!/bin/bash
while true; do
    if [ -f "${MOUNT_POINT}/update_hosts.txt" ]; then
        NEW_ENTRY=$(cat "${MOUNT_POINT}/update_hosts.txt")
        WORKER_ENTRY=$(grep "k8s-worker.*" "${MOUNT_POINT}/update_hosts.txt")
        sudo sed -i "s/.*$${WORKER_ENTRY}.*/$${NEW_ENTRY}/g" /etc/hosts
        sudo rm "${MOUNT_POINT}/update_hosts.txt"
    else
        sleep 120
    fi
done
EOF

sudo chmod +x /home/ubuntu/hosts_watcher.sh
nohup /home/ubuntu/hosts_watcher.sh > /home/ubuntu/hosts_watcher.log 2>&1 &

# Initializing Kubernetes master node
sudo kubeadm init

# Configuring kubectl for the ubuntu user
mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sleep 10

# Deploying Weave Net CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

# Saving the join command for worker nodes
mkdir -p ${MOUNT_POINT}
touch ${MOUNT_POINT}/join_command.txt
sudo kubeadm token create --print-join-command --ttl=0 > ${MOUNT_POINT}/join_command.txt

#Creating directories for manifest files
mkdir -p /home/ubuntu/services/
mkdir -p /home/ubuntu/deployments/

# Downloading the manifest files from S3 into the directories 
aws s3 cp s3://k8-manifest-bucket/k8-clixx-service.yaml /home/ubuntu/services/
aws s3 cp s3://k8-manifest-bucket/k8-clixx-deployment.yaml /home/ubuntu/deployments/
aws s3 cp s3://k8-manifest-bucket/k8-cred-for-ecr.sh /home/ubuntu/

sh /home/ubuntu/k8-cred-for-ecr.sh

# Waiting for the named pipe signal to apply the deployment
echo "Waiting for message from SIGNAL..."
while  [ ! -e "$${signal}" ]; do
    sleep 10
done

# Applying the Kubernetes deployment and service files
kubectl apply -f /home/ubuntu/services/k8-clixx-service.yaml
sleep 10
kubectl apply -f /home/ubuntu/deployments/k8-clixx-deployment.yaml
echo "Application deployment complete." >> /home/ubuntu/startup.log

echo "All systems operational" >> /home/ubuntu/startup.log

mysql -h "${DB_HOST}" -u "${DB_USER_CLIXX}" -p"${DB_PASS_CLIXX}" "${DB_NAME_CLIXX}" <<EOF
Update wp_options SET option_value = "${CLIXX_LB}" WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE wp_options SET option_value = "${CLIXX_LB}" WHERE option_value LIKE '%NLB%';
EOF