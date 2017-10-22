#!/bin/bash

if [[ "$1" ]]
then
  iptables -I INPUT -s "$1" -j DROP
  iptables -I INPUT -d "$1" -j DROP
  iptables -vL -n
else
  echo "You need to specify IP to ban"
fi
