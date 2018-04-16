# Step-by-Step guide to a ZOC Masternode setup
A novices guide to an Ubuntu 16.04 install

***

## 1. Send 1000 coins to yourself.

If you haven't done so already, install the windows wallet from https://github.com/zocteam/zeroonecoin/releases 
Create a new receive address and call it something like MN1. Although I like to call mine the name of my server so it's easier to track which VPS each MN is installed on.

Then send 1000 ZOC coins to the address you just created. Make sure the address receives EXACTLY 1000 coins, so DO NOT tick the "Subtract fee from amount" option.
We now need to *wait* for 15 confirmations of the transaction so we'll get on with the remote VPS install.



## 2. VPS

Order a VPS. A VPS with 1GB RAM works great for me. I choose the Ubuntu 16.04 (server version without a desktop) operating system to install on although it would be easier to install on 14.04 with other scripts which are available and can find on the Discord server here: https://discord.gg/JGBpp 
I prefer 16.04 so that I can install other coin MN's on the same VPS, and I also prefer to compile it myself which is what this script does. It takes longer but I only have to do it once.
A tried and tested place to get a VPS is from: https://goo.gl/hv2Hfc 



## 3. PuTTY Install

If you haven't got any SSH client installed already, please download and run PuTTY from https://www.putty.org/



## 4. New User

Your VPS provider will give you an IP address and a root password for your new server.
Login in to your server with PuTTY using the IP address. Your username will be "root" and the password is the root password.
For this guide I'll use the username "zocuser", you can use whatever username you like. Create a strong password for this user and you can skip past the options asking for your name etc. Type on the command line:

```
adduser zocuser
```

Then make the user a sudoer so he can do root things.

```
usermod -aG sudo zocuser
```



## 5. Create Swap file

Some people have needed more RAM to complete compiling the required software. If you don't need this, skip this step. If you need it, paste the following in to the command line. And then reboot your server.

```
dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000
mkswap /mnt/myswap.swap
chmod 600 /mnt/myswap.swap
swapon /mnt/myswap.swap
echo -e "/mnt/myswap.swap none swap sw 0 0 \n" >> /etc/fstab

reboot
```

Now log back in using the same IP address, but with the username "zocuser" and the password you chose.



## 6. SETUP

As it takes a while to install, we first need to increase the time that a user can have sudo (root) rights. So type the following:

```
sudo visudo
```

Go down to the line which looks like:

```
Defaults      env_reset
```

and add the following at the end to change it to this:

```
Defaults      env_reset,timestamp_timeout=60
```

then save and exit by pressing CTRL-X, Y and then hitting ENTER.

Now copy and paste the following into the command line. Enter your password if asked and let it run. It will take a long time.

```
wget https://raw.githubusercontent.com/MadStu/ZOC/master/ZOCinstall.sh
chmod 777 ZOCinstall.sh
sed -i -e 's/\r$//' ZOCinstall.sh
./ZOCinstall.sh
```

It may ask you stuff during the process, if it asks to reinstall things which are already installed, just choose yes. And it may also occasionally ask for your password as you'll be sudoing some tasks (which means running with root permissions).
At the end it'll tell you your masternode key which you'll need to copy and paste into your windows wallet masternode configuration file.



## 7. Configure Windows wallet

Once the 1000 coins you sent earlier has 15 confirmations, you can grab your Transaction ID and VOUT.
Go to the debug console and type:

```
masternode outputs
```

You'll see something like this:

```
"f5d4ec12b6ab68977eed84913255ea6685110e5f781e5e525a12bc2fd1c6b9d": "1"
```

The first part is your TRANSACTION ID - the second part is your VOUT.
Now open up the masternode configuration file by clicking Tools -> Open Masternode Configuration File Under all # put a new line which consists of the following data from your skeletion:

```
MN1 MASTERNODE_PUBLIC_IP:10000 MASTERNODE_KEY TRANSACTION_ID VOUT
```

Save and close the file.
Make sure you have the masternode tab enabled in the settings by going to Settings->Options->Wallet->Show Masternode.
Close and restart the wallet.



## 8. Start your Masternode

On the VPS, type the command:

```
zeroone-cli mnsync status
```

You will see an AssetID number. If the number is NOT 999, then you must wait.

Every 1 or 2 minutes, type the zeroone-cli mnsync status command.

Once you see it says AssetID: 999 THEN you can Start Alias on your windows wallet.

Start it by going to the masternode tab, right clicking on your masternode and choosing to "Start Alias".




# Donations

Any donation is highly appreciated  





**ZOC**: ZUb9h1F5yrut26hnFMjZa6PwbakR7WSudb 

**BTC**: 3MprejNeXAHVvNA4mfrMzymZakE7x2Efra 

**ETH**: 0x9B11A49423bb65936D03df9abB98d00B438b0010 

**LTC**: MC7HmFHhHPQg3pFbzeuTPPXXPe3SZWJJHE 





**Good luck!**