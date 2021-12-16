#!/bin/bash
sudo apt-det -y update
sudo apt-get install -y nginx
azcopy copy "https://examplestoracc8011.blob.core.windows.net/content/index.html" "/usr/share/nginx/html/index.html"
sudo systemctl start nginx
sudo systemctl enable nginx