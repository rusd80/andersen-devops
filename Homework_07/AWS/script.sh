#!/bin/bash
sudo yum -y update
sudo amazon-linux-extras install nginx1 -y
aws s3 cp s3://bucketrusd80/index.html /usr/share/nginx/html/index.html
echo $HOSTNAME >> /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx