clear
echo "==============================="
echo "==                           =="
echo "==  MadStu's Reindex Script  =="
echo "==                           =="
echo "==============================="
echo " "
if [ -e getinfo.json ]
then
	echo "Script running already"
else
echo "blah" > getinfo.json
zeroone-cli stop
sleep 5
cd ~/.zeroonecore
rm mncache.dat
rm mnpayments.dat
zerooned -daemon -reindex
sleep 2
ARRAY=$(zeroone-cli getinfo)
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
			sleep 60
			BLOCKCOUNT=$(curl https://explorer.01coin.io/api/getblockcount)
			ARRAY=$(zeroone-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
echo "Now wait for AssetID: 999..."
sleep 3
MNSYNC=$(zeroone-cli mnsync status)
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
			echo "  AssetID: $ASSETID"
			sleep 10
			MNSYNC=$(zeroone-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
zeroone-cli mnsync status
echo " "
echo " "
echo "  You can now Start Alias in the windows wallet!"
rm getinfo.json

fi
