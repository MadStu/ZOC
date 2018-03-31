#!/bin/bash

echo "Please enter the password for your user account if asked..."
sleep 3
sudo apt-get update -y
sudo apt-get install -y pwgen
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo mkdir $HOME/tempZOC
sudo chmod -R 777 $HOME/tempZOC
sudo git clone https://github.com/zocteam/zeroonecoin $HOME/tempZOC
cd $HOME/tempZOC
sudo chmod 777 autogen.sh
sudo ./autogen.sh
sudo ./configure
sudo chmod +x share/genbuild.sh
sudo make
sudo make install
cd $HOME
sudo mkdir $HOME/zeroonecoin
sudo mkdir $HOME/.zeroonecore
cp $HOME/tempZOC/src/zerooned $HOME/zeroonecoin
cp $HOME/tempZOC/src/zeroone-cli $HOME/zeroonecoin
sudo chmod -R 777 $HOME/zeroonecoin
sudo chmod -R 777 $HOME/.zeroonecore
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=9998\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:10000\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=128.199.62.128\naddnode=159.65.24.219\naddnode=188.166.91.38\naddnode=174.138.10.244\naddnode=128.199.62.128\naddnode=103.69.195.185:58848\naddnode=13.56.174.183:10000\naddnode=13.59.197.120:10000\naddnode=144.202.17.171:10000\naddnode=174.138.10.244:10000\naddnode=185.224.249.58:45325\naddnode=213.183.51.7:10000\naddnode=45.32.6.178:34558\naddnode=62.77.153.115:10000\naddnode=79.165.207.31:57377\naddnode=90.145.172.88:10000\naddnode=90.156.157.28:10000\n\n" > /$HOME/.zeroonecore/zeroone.conf
zerooned -daemon
sleep 10
MKEY=$(zeroone-cli masternode genkey)
zeroone-cli stop
sleep 2
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.zeroonecore/zeroone.conf
sleep 2
sudo rm -rf $HOME/tempZOC
zerooned -daemon
sleep 3
zeroone-cli mnsync status
sleep 1
echo "Now would be a good time to setup your Transaction ID and VOUT on your windows wallet"
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP:10000"
sleep 3
echo "Now you can keep checking your Masternode sync status by typing:"
echo "zeroone-cli mnsync status"
echo "Once you see AssetID: 999, you can then Start Alias in the windows wallet."
sleep 3
echo "Good luck! You got this!!"