#!/bin/sh
i=0

while true
do
  R=`tail -n 1 $1 | sed -e 's/ //g'`

  if [ $(echo $R | grep -e "ABCDEFGHIJKLMN") ]; then
    continue
  fi

  if [ $i -eq "2" ]; then
    echo "exec"
    iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j REDIRECT --to-port 8080
  fi

  if [ $(echo $R | grep -e "KEY WORD") ]; then
    i=`expr $i + 1`
    echo "ABCDEFGHIJKLMN" >>  $1
  else
    i=0
  fi

done


# sudo iptables -t nat -L --line-numbers
# sudo iptables -t nat -D PREROUTING [N]