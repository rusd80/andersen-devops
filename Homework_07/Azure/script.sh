#!/usr/bin/env bash
sudo apt-get -y update
sudo apt-get install -y nginx
sudo chmod 777 /var/www/html/index.nginx-debian.html
sudo mkdir /mnt/myfilestorage
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/storagepagerusd801.cred" ]; then
    sudo bash -c 'echo "username=storagepagerusd801" >> /etc/smbcredentials/storagepagerusd801.cred'
    sudo bash -c 'echo "password=2QTEFIshElQ3q0hN9/gD3+4t4Djx9vhG+km6niZOir3r7NheWHEytPkOoUY3chTM+qIRXBn1dOhtOWdk0Jiv4g==" >> /etc/smbcredentials/storagepagerusd801.cred'
fi
sudo chmod 600 /etc/smbcredentials/storagepagerusd801.cred
sudo bash -c 'echo "//storagepagerusd801.file.core.windows.net/myfilestorage /mnt/myfilestorage cifs nofail,vers=3.0,credentials=/etc/smbcredentials/storagepagerusd801.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //storagepagerusd801.file.core.windows.net/myfilestorage /mnt/myfilestorage -o vers=3.0,credentials=/etc/smbcredentials/storagepagerusd801.cred,dir_mode=0777,file_mode=0777,serverino
sudo mv /mnt/myfilestorage/index.html /var/www/html/index.nginx-debian.html
sudo service nginx restart
