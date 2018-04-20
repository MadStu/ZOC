clear
sleep 1
if [ -e getinfo.json ]
then
	echo " "
	echo "Script running already?"
	echo " "

else
echo "blah" > getinfo.json

sudo apt-get install jq pwgen -y

#killall zerooned
#rm -rf zero*
#rm -rf .zero*
wget https://github.com/zocteam/zeroonecoin/releases/download/V0.12.1.6/zeroone-linux.tar.gz
tar -xvzf zeroone-linux.tar.gz



mkdir ~/.zeroonecore
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=10100\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:10000\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=01coin.io\n\n" > ~/.zeroonecore/zeroone.conf

~/zeroone/zerooned -daemon
sleep 10
MKEY=$(~/zeroone/zeroone-cli masternode genkey)
~/zeroone/zeroone-cli stop
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.zeroonecore/zeroone.conf
sleep 10
~/zeroone/zerooned -daemon







sleep 10
ARRAY=$(~/zeroone/zeroone-cli getinfo)
echo "$ARRAY" > getinfo.json
BLOCKCOUNT=$(curl https://explorer.01coin.io/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors or 'Blocks required' is blank,"
			echo "    you are safe to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the block"
			echo "    sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the race.conf file."
			echo " "
			sleep 20
			BLOCKCOUNT=$(curl https://explorer.01coin.io/api/getblockcount)
			ARRAY=$(~/zeroone/zeroone-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
#echo "Now wait for AssetID: 999..."
sleep 1
MNSYNC=$(~/zeroone/zeroone-cli mnsync status)
echo "$MNSYNC" > mnsync.json
ASSETID=$(jq '.AssetID' mnsync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  Looking for: 999"
			echo "      AssetID: $ASSETID"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors, you are safe"
			echo "    to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the"
			echo "    block sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the race.conf file."
			echo " "
			sleep 5
			MNSYNC=$(~/zeroone/zeroone-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
~/zeroone/zeroone-cli mnsync status
echo " "




sleep 3 
echo " "
echo " "
echo "Now would be a good time to setup your Transaction ID and VOUT from your windows wallet"
echo " "
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
echo " "
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP"
echo " "
sleep 2
echo "=================================="
echo " "
echo "So your masternode.conf should start with:"
echo " "
THISHOST=$(hostname -f)
echo "$THISHOST $EXIP:10000 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
echo "Your server hostname is $THISHOST and you can change it to MN1 or MN2 or whatever you like"
echo " "
sleep 3
echo " "
echo "  - You can now Start Alias in the windows wallet!"
echo " "
echo "       Thanks for using MadStu's Install Script"
echo " "


rm getinfo.json

fi

