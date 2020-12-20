#!/bin/bash -e
if [ -f "/opt/update.next" ]; then
  apt-get update --yes
  apt-get upgrade --yes

  cd ~/Ixian/Ixian-Pool
  git pull
  
  DLT_HOST=`sed -n 's/^$dlt_host\s*=\s*\"\(.*\)\"\s*;/\1/p' /var/www/html/config.php`
  POOL_FEE=`sed -n 's/^$poolfee\s*=\s*\(.*\);/\1/p' /var/www/html/config.php`
  POOL_REWARD_ADDRESS=`sed -n 's/^$poolfee_address\s*=\s*\"\(.*\)\"\s*;/\1/p' /var/www/html/config.php`
  POOL_NAME=`sed -n 's/^$pool_name\s*=\s*\"\(.*\)\"\s*;/\1/p' /var/www/html/config.php`
  POOL_URL=`sed -n 's/^$pool_url\s*=\s*\"\(.*\)\"\s*;/\1/p' /var/www/html/config.php`

  cp -R ~/Ixian/Ixian-Pool/www/* /var/www/html/
  sed -i "/^\$db_host\s*=.*/ s//\$db_host = \"localhost\";/" /var/www/html/config.php
  sed -i "/^\$db_user\s*=.*/ s//\$db_user = \"ixian\";/" /var/www/html/config.php
  sed -i "/^\$db_pass\s*=.*/ s//\$db_pass = \"ixian\";/" /var/www/html/config.php

  sed -i "/^\$dlt_host\s*=.*/ s//\$dlt_host = \"$DLT_HOST\";/" /var/www/html/config.php

  sed -i "/^\$poolfee\s*=.*/ s//\$poolfee = $POOL_FEE;/" /var/www/html/config.php
  sed -i "/^\$poolfee_address\s*=.*/ s//\$poolfee_address = \"$POOL_REWARD_ADDRESS\";/" /var/www/html/config.php
  sed -i "/^\$pool_name\s*=.*/ s//\$pool_name = \"$POOL_NAME\";/" /var/www/html/config.php
  sed -i "/^\$pool_url\s*=.*/ s//\$pool_url = \"$POOL_URL\";/" /var/www/html/config.php
  
  rm ~/update.next
fi

service mysql restart
service apache2 restart
service cron restart

sleep infinity