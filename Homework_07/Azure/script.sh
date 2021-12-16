#!/bin/bash
sudo apt-get -y update
sudo apt-get install -y nginx
sudo mkdir /mnt/sharefile
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/storagepagerusd801.cred" ]; then
    sudo bash -c 'echo "username=storagepagerusd801" >> /etc/smbcredentials/storagepagerusd801.cred'
    sudo bash -c 'echo "password=+qxTd6iSDYNRHLLoCMzPidqO4/MGTBVCgT+i2AIIgJWt/eoB39LMwtrIA78lHcEJB9AxL8QwROnvgwj0484lqA==" >> /etc/smbcredentials/storagepagerusd801.cred'
fi
sudo chmod 600 /etc/smbcredentials/storagepagerusd801.cred
sudo bash -c 'echo "//storagepagerusd801.file.core.windows.net/sharefile /mnt/sharefile cifs nofail,vers=3.0,credentials=/etc/smbcredentials/storagepagerusd801.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //storagepagerusd801.file.core.windows.net/sharefile /mnt/sharefile -o vers=3.0,credentials=/etc/smbcredentials/storagepagerusd801.cred,dir_mode=0777,file_mode=0777,serverino
sudo cp /mnt/sharefile/index.html /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx

