#!/bin/bash
sudo apt-det -y update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx