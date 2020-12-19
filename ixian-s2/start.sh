#!/bin/bash -e
if [ -f "~/update.next" ]; then
  cd ~/Ixian/Ixian-Core
  git pull
  cd ~/Ixian/Ixian-S2
  git pull
	sh rebuild.sh
	rm ~/update.next
fi

WALLET_PASSWORD=`cat ~/wallet_pwd`

cd ~/Ixian/Ixian-S2/IxianS2/bin/Release
mono IxianS2.exe --walletPassword $WALLET_PASSWORD