#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/ZOC/master/newzocmn.sh
chmod 777 newzocmn.sh
sed -i -e 's/\r$//' newzocmn.sh
./newzocmn.sh
