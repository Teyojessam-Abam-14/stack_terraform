#!/bin/bash -xe

#Update the system packages
sudo yum update -y
# install LAMP stack using Amazon Linux extras
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server

# Start and enable Apache HTTP Server
sudo systemctl start httpd
sudo systemctl enable httpd

# Check if Apache HTTP server is enabled
sudo systemctl is-enabled httpd

#check test page
sudo usermod -a -G apache ec2-user

#checking the groups to verify addition of 'apache'
groups

#Set permissions and ownership for /var/www/ directory
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

# INSTALL PHP MY ADMIN
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
rm /var/www/html/phpinfo.php
sudo systemctl start mariadb

#set root password for mysql and perform initial configurations
mysql -u root << EOF
UPDATE mysql.user SET authentication_string = PASSWORD('root') WHERE User = 'root';
DELETE FROM mysql.user WHERE user='';
DELETE FROM mysql.user WHERE User = 'root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

#Install addition PHP stuff and restarting services
sudo yum install php-mbstring -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm

#Downloading and Extract PHPMyAdmin
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz

#dns check phpmyadmin
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo systemctl start mariadb

#Setting up  wordpress database and configuration
DB_NAME="wordpress-db"
DB_USER="stack_yinkar"
DB_PASSWORD="stackinc"
DB_EMAIL="olayinkarasheed246@gmail.com"

mysql -u root <<EOF
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY 'stackinc';
CREATE DATABASE \`$DB_NAME\`;
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF


cp wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

####
WP_CONFIG=/var/www/html/wordpress/wp-config.php

#Update wordpress config with db details
sed -i "s/'database_name_here'/'$DB_NAME'/g" $WP_CONFIG
sed -i "s/'username_here'/'$DB_USER'/g" $WP_CONFIG
sed -i "s/'password_here'/'$DB_PASSWORD'/g" $WP_CONFIG

#copy wordpress files to the webserver root
mkdir /var/www/html/blog
cp -r wordpress/* /var/www/html/

#####Modify Apache HTTP server config
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf


#set permissions and ownership for /var/www directory
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

#restart apache http server and enable services
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb

#sudo systemctl status of MySQL and apache HTTP server
sudo systemctl status mariadb
sudo systemctl status httpd


#######################################
# Download WP-CLI
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make WP-CLI executable
sudo chmod +x wp-cli.phar

# Move WP-CLI to a location in the user's PATH
sudo mv wp-cli.phar /usr/local/bin/wp

IP_ADDRESS=$(curl -s http://checkip.amazonaws.com)

wp core install --url="http://{$IP_ADDRESS}" --title="Welcome To Yinka's Blog" --admin_user="$DB_USER" --admin_password="$DB_PASSWORD" --admin_email="$DB_EMAIL" --path=/var/www/html/

cd /var/www/html

sudo find . -type d -exec chmod 0755 {} \;
sudo find . -type f -exec chmod 0644 {} \;
sudo chown -R ec2-user:apache .
sudo chmod -R g+w . 
sudo chmod g+s .


# Install a WordPress theme
wp theme install twentyseventeen --activate

# Restart Apache to make sure all changes take effect
sudo systemctl restart httpd
