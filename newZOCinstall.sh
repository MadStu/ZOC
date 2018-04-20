#!/bin/bash

echo "Please enter the password for your user account if asked..."
sleep 3
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git -y
sudo apt-get install build-essential pwgen jq libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo mkdir $HOME/tempZOC
sudo chmod -R 777 $HOME/tempZOC
sudo git clone https://github.com/zocteam/zeroonecoin $HOME/tempZOC
cd $HOME/tempZOC
wget https://files.01coin.io/c55efab268e63aa1217d0c511fe1029f/premine.patch
sudo git apply premine.patch
sudo chmod 777 autogen.sh
sudo ./autogen.sh
sudo ./configure --without-gui
sudo chmod +x share/genbuild.sh
sudo make
sudo make install
cd $HOME
sudo mkdir $HOME/zeroonecoin
sudo mkdir $HOME/.zeroonecore
sudo chmod -R 777 $HOME/zeroonecoin
sudo chmod -R 777 $HOME/.zeroonecore
sudo cp $HOME/tempZOC/src/zerooned $HOME/zeroonecoin
sudo cp $HOME/tempZOC/src/zeroone-cli $HOME/zeroonecoin
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=9998\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:10000\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=80.211.134.175:10000\naddnode=94.177.170.193:10000\naddnode=80.211.187.187:10000\naddnode=199.247.28.109:10000\naddnode=80.211.219.176:10000\naddnode=185.33.145.138:10000\n\n" > /$HOME/.zeroonecore/zeroone.conf
zerooned -daemon
sleep 3
MKEY=$(zeroone-cli masternode genkey)
zeroone-cli stop
sleep 1
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.zeroonecore/zeroone.conf
zerooned -daemon
sleep 3
zeroone-cli mnsync status
sleep 3
zerooned -version
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP:10000"
