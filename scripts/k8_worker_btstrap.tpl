#!/bin/bash 

#Defining node status
node_status="undefined"

sudo apt-get update 
sudo apt-get install nfs-common -y
sudo snap install aws-cli --classic
sudo apt install mysql-server -y
sudo apt install mysql-client -y
sudo systemctl restart containerd
sudo systemctl restart docker
sudo echo 'alias init="sudo tail -40f /var/log/cloud-init-output.log"' >> /home/ubuntu/.bashrc

source ~/.bashrc

# Setting named pipe variable
signal=${MOUNT_POINT}/proceed_signal

cd /home/ubuntu
touch /home/ubuntu/startup.log

# Turning off swap
sudo swapoff -a
echo "swap turned off" > /home/ubuntu/startup.log

# Getting the server's private IP address
private_ip=$(ip address | grep eth0 | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}')
echo "$${private_ip}" >> /home/ubuntu/startup.log

# Define the mount options in a variable
MOUNT_OPTIONS="nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev"

# Making mount point if it doesnt exist already
sudo mkdir -p "${MOUNT_POINT}"

# Adding to /etc/fstab if not already present
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
    sleep 10
  fi
done

# Ensuring all filesystems from fstab are mounted
sudo mount -a -t nfs4

sudo chown ubuntu "${MOUNT_POINT}"

# Checking and setting hostnames
if ! [ -e ${MOUNT_POINT}/node_names ]; then
    sudo touch ${MOUNT_POINT}/node_names
    echo "node1: reserved" > ${MOUNT_POINT}/node_names
    echo "node2: available" >> ${MOUNT_POINT}/node_names
    echo "node3: available" >> ${MOUNT_POINT}/node_names
    node_name="node1"
    sudo hostnamectl set-hostname $${node_name}
    hostname >> /home/ubuntu/startup.log
    echo "Node names file created and node1 reserved" >> /home/ubuntu/startup.log
    touch ${MOUNT_POINT}/setup_done
else
    echo "Node names file already exists" >> /home/ubuntu/startup.log
    node_name="unknown"
fi

if [ $${node_name} == "unknown" ]; then
    sleep 30
    loop_control="wait"
    echo 'setup_done not found' >> /home/ubuntu/startup.log
    while [ "$${loop_control}" == "wait" ]; do
        if [ -e ${MOUNT_POINT}/setup_done ]; then
            loop_control="proceed"
        else
            sleep 30
        fi
    done
    sudo sed -i 's/node2: available/node2: reserved/g' ${MOUNT_POINT}/node_names
    node_name="node2"
    sudo hostnamectl set-hostname $${node_name}
    hostname >> /home/ubuntu/startup.log
fi

if ! [ -e ${MOUNT_POINT}/hosts_list.txt ]; then
    sleep 30
    loop_control="wait"
    while [ "$${loop_control}" == "wait" ]; do
        if [ -e ${MOUNT_POINT}/hosts_list.txt ]; then
            loop_control="proceed"
        else
            sleep 30
        fi
    done
fi

# Writing to hosts_list.txt
echo "$${private_ip} $${node_name}" >> ${MOUNT_POINT}/hosts_list.txt

line_count=$(wc -l < ${MOUNT_POINT}/hosts_list.txt)

if [ $${line_count} != 3 ]; then
    loop_control="wait"
    sleep 20
    while [ "$${loop_control}" == "wait" ]; do
        line_count=$(wc -l < ${MOUNT_POINT}/hosts_list.txt)
        if [ $${line_count} != 3 ]; then
            sleep 20
        else
            loop_control="proceed"
        fi
    done
fi


# Updating /etc/hosts
while true; do
    if grep -q "node1" "${MOUNT_POINT}/hosts_list.txt" && grep -q "node2" "${MOUNT_POINT}/hosts_list.txt" && grep -q "k8s-master" "${MOUNT_POINT}/hosts_list.txt"; then
        echo "All nodes are found in the file."
        break
    else
        echo "One or more nodes not found. Sleeping for 10 seconds..."
        sleep 10
    fi
done

config_contents=$(cat ${MOUNT_POINT}/hosts_list.txt)
echo "$${config_contents}" >> /etc/hosts

# Joining Kubernetes cluster
if ! [ -e ${MOUNT_POINT}/join_command.txt ]; then
    loop_control="wait"
    while [ "$${loop_control}" == "wait" ]; do
        if [ -e ${MOUNT_POINT}/join_command.txt ]; then
            loop_control="proceed"
            join_cmd=$(cat ${MOUNT_POINT}/join_command.txt)
            $${join_cmd}
        else
            sleep 30
        fi
    done
fi

# Creating named pipe if it doesn't exist
if ! [ -e $${signal} ]; then
    touch $${signal}
    sleep 5
    echo "Proceed signal received!" > $${signal}
fi

echo "All systems operational" >> /home/ubuntu/startup.log
