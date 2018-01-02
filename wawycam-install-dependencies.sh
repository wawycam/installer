#!/bin/bash


echo ""
echo "WaWyCam Installer"
echo ""

DESTINATION="/home/pi/wawycam"
mkdir ${DESTINATION}

apt-get update
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

apt-get install -y nodejs
apt-get install -y git
apt-get install -y hostapd 
apt-get install -y dnsmasq
apt-get install -y imagemagick
apt-get install -y mongodb-server
apt-get install -y nginx
apt-get install -y libcairo2-dev
apt-get install -y libjpeg-dev 
apt-get install -y libgif-dev
apt-get install -y libpango1.0-dev
apt-get install -y build-essential
apt-get install -y g++
apt-get install -y ffmpeg
apt-get install -y libharfbuzz0b
apt-get install -y libfontconfig1

echo "Install PICAM"

wget https://github.com/iizukanao/picam/releases/download/v1.4.6/picam-1.4.6-binary-stretch.tar.xz
tar -xvf picam-1.4.6-binary-stretch.tar.xz
mv picam-1.4.6-binary-stretch $DESTINATION/picam
rm -rf picam-1.4.6-binary-stretch.tar.xz

npm install pm2 -g
npm install node-gyp -g

echo "Install WAWY CAMERA API"

chown -R pi:pi ${DESTINATION}
sudo -u pi bash << EOF

cd ${DESTINATION}
wget http://wawy.io/builds/cam-api-tarball/cam-api-latest.tgz

# Extract latest
tar -xvf cam-api-latest.tgz

# Delete tarball
rm -rf cam-api-latest.tgz

# Install dependencies
cd ${DESTINATION}/api
npm install

sudo -s

# Start API server
npm start


