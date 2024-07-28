#!/bin/bash

# Update system packages
sudo yum update -y

# Install ECS agent and start Docker
sudo amazon-linux-extras install -y ecs
sudo yum install -y ecs-init
sudo yum install mysql -y
sudo yum install -y aws-cli
sudo yum install -y nfs-utils
sudo yum install wget -y

# Create the ECS configuration script
echo '#!/bin/bash' > /home/ec2-user/ecs_config.sh
echo 'sleep 120' >> /home/ec2-user/ecs_config.sh
echo 'echo ECS_CLUSTER='${CLUSTER_NAME}' >> /etc/ecs/ecs.config' >> /home/ec2-user/ecs_config.sh
chmod 744 /home/ec2-user/ecs_config.sh

# Run the ECS configuration script in the background
sh /home/ec2-user/ecs_config.sh 1>/home/ec2-user/config_out.txt 2>/home/ec2-user/config_out.txt & disown

# Start Docker service
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Update tcp_keepalive settings
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

# Uncomment and modify the EFS mount section if needed
# EFS_DNS=<your EFS DNS>
# MOUNT_POINT=/mnt/efs
# sudo mkdir -p ${MOUNT_POINT}
# sudo chown ec2-user:ec2-user ${MOUNT_POINT}
# echo "${EFS_DNS}:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" | sudo tee -a /etc/fstab
# sudo mount -a -t nfs4

# Uncomment and modify the CloudWatch agent section if needed
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
# sudo rpm -U ./amazon-cloudwatch-agent.rpm
# sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
# sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null << 'EOF'
# {
#     "metrics": {
#         "metrics_collected": {
#             "mem": {
#                 "measurement": [
#                     "mem_used_percent"
#                 ],
#                 "metrics_collection_interval": 30
#             }
#         }
#     }
# }
# EOF
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# Allow some time for services to initialize
sleep 100

# Update ecs-init
sudo yum install -y ecs-init
sudo yum update -y ecs-init
sudo chmod 666 /var/run/docker.sock

# Indicate completion
echo "done" > /home/ec2-user/done.txt

# Update MySQL database values
mysql -h "${DB_HOST}" -u "${DB_USER_CLIXX}" -p"${DB_PASS_CLIXX}" -D "${DB_NAME_CLIXX}" <<EOF
UPDATE wp_options SET option_value = '${CLIXX_LB}' WHERE option_name = 'siteurl' OR option_name = 'home';
EOF
