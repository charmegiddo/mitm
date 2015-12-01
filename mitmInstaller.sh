#!/bin/bash
echo "#####################################################################
#     #   ###   ####### #     #
##   ##    #       #    ##   ##
# # # #    #       #    # # # #
#  #  #    #       #    #  #  #
#     #    #       #    #     #
#     #    #       #    #     #
#     #   ###      #    #     #

###   #     #  #####  #######    #    #       #       ####### ######
 #    ##    # #     #    #      # #   #       #       #       #     #
 #    # #   # #          #     #   #  #       #       #       #     #
 #    #  #  #  #####     #    #     # #       #       #####   ######
 #    #   # #       #    #    ####### #       #       #       #   #
 #    #    ## #     #    #    #     # #       #       #       #    #
###   #     #  #####     #    #     # ####### ####### ####### #     #
#####################################################################"

echo "Require Environment: RASPBIAN JESSIE ver 4.x"

osver=`uname -a | grep -e 'Linux raspberrypi 4.'`

if [ -n "${osver}" ]; then
   echo "[OK]$osver
"
else
    echo "[Unknown OS]$osver
may not be able to install."
fi

while true
do
    echo -n "python-pip, python-dev, libxml2-dev, libxslt-dev, 
libffi-dev, python-lxml, dsniff, libjpeg-dev, libfreetype6,
libfreetype6-dev, zlib1g-dev, mitmproxy
Install the above for this machine use the mitmproxy and arpspoof [y/n] :"
    read ANS
    if [ "${ANS}" = 'y' -o "${ANS}" = 'yes' ]; then
        break
    elif [ "${ANS}" = 'n' -o "${ANS}" = 'no' ]; then
        exit 1
    else
        continue 1
    fi
done

sudo apt-get -y update 
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
#sudo apt-get -y install python-pip
sudo apt-get install -y python-dev libxml2-dev libxslt-dev libffi-dev python-lxml
sudo apt-get -y install libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev
sudo apt-get -y remove python-pyasn1 
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
chmod +x get-pip.py
sudo ./get-pip.py
sudo pip install pyasn1
sudo apt-get -y install dsniff
sudo pip install mitmproxy

echo "Done."