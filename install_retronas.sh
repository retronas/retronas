#!/bin/bash

echo
echo "Updating repo cache..."
apt update

echo
echo "Installing necessary tools..."
apt install -y git

echo
echo "Downloading RetroNAS..."
cd /opt
git clone 'https://github.com/danmons/retronas.git'
chmod a+x /opt/retronas/retronas.sh

echo
echo "All done.  You can now run the RetroNAS config tool with the following command:"
echo
echo "sudo /opt/retronas/retronas.sh"
echo
