#!/bin/bash xe

#Downloading PEM Key from S3
aws s3 cp s3://${S3_BUCKET}/${PEM_KEY} /home/ec2-user/${PEM_KEY}

#changing permission of pem key
chmod 400 /home/ec2-user/${PEM_KEY}

Change directory to /opt/
cd /opt/

Create a directory named 'oracle' under /opt
sudo mkdir oracle 

Change directory to /opt/oracle/
cd oracle

Download Oracle Instant Client basic RPM package from Oracle's website
sudo wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm

Install Oracle Instant Client basic package from the downloaded RPM package
sudo rpm -ivh oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm

Download Oracle Instant Client SQL*Plus RPM package from Oracle's website
sudo wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm

Install Oracle Instant Client SQL*Plus package from the downloaded RPM package
sudo rpm -ivh oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm

Change directory to /home/ec2-user
cd /home/ec2-user


# Figure out how to add bootstrap code to log in Bastion as root user 
# #Go to root user (make sure to ssh into Bastion server as root user, not ec2-user, locally)
# sudo su -

# #Move to the directory where the PEM key lives (then, ssh into App server as ec2-user via Bastion server)
# cd /home/ec2-user
