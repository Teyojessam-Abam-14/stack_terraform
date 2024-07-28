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
