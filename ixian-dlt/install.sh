#!/bin/bash -e
if [ $# -ne 7 ]; then
	echo "Setup requires 7 parameters"
  exit 1
fi

URL=$1
BRANCH=$2
SHA=$3
BOOTSTRAP_URL=$4
GENESIS_FILE=$5
WALLET_FILE=$6
WALLET_PASSWORD=$7

mkdir ~/Ixian
cd ~/Ixian

echo "Fetching Ixian-Core and Ixian-DLT"
git clone -b "$BRANCH" "$URL/Ixian-Core.git"
git clone -b "$BRANCH" "$URL/Ixian-DLT.git"

cd Ixian-DLT
sh rebuild.sh

if [ "$WALLET_FILE" != "/opt/Ixian/Ixian-DLT/IxianDLT/bin/Release/ixian.wal" ]; then
  cp $WALLET_FILE /opt/Ixian/Ixian-DLT/IxianDLT/bin/Release/ixian.wal
fi
echo $WALLET_PASSWORD > ~/wallet_pwd

echo "apiBind = http://*:8081/" > ~/Ixian/Ixian-DLT/IxianDLT/bin/Release/ixian.cfg
