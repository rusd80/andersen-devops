#!/bin/bash
sudo apt-get -y update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx