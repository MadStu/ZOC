#!/bin/sh
cd ~
sudo apt-get -y update
sudo apt-get -y install virtualenv python-virtualenv
git clone https://github.com/zocteam/sentinel.git zoc_sentinel
cd zoc_sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
crontab -l > mycron
echo "* * * * * cd $(pwd) && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
~/zoc_sentinel
./venv/bin/py.test ./test
