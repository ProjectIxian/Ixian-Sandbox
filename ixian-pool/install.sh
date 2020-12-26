#!/bin/bash -e
if [ $# -ne 8 ]; then
	echo "Setup requires 8 parameters"
  exit 1
fi

URL=$1
BRANCH=$2
SHA=$3
POOL_REWARD_ADDRESS=$4
POOL_FEE=$5
POOL_NAME=$6
POOL_URL=$7
ESCAPED_POOL_URL=$(printf '%s\n' "$POOL_URL" | sed -e 's/[\/&]/\\&/g')
DLT_URL=$8
ESCAPED_DLT_URL=$(printf '%s\n' "$DLT_URL" | sed -e 's/[\/&]/\\&/g')

mkdir ~/Ixian
cd ~/Ixian

export DEBIAN_FRONTEND="noninteractive"
apt-get install cron -y
apt-get install apache2 -y
apt-get install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath -y
apt-get install mariadb-server -y

service mysql restart

a2enmod ssl
a2enmod rewrite
a2ensite default-ssl
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
service apache2 restart

echo "Fetching Ixian-Pool"
git clone -b "$BRANCH" "$URL/Ixian-Pool.git"

cp -R /opt/Ixian/Ixian-Pool/www/. /var/www/html/
rm /var/www/html/index.html

sed -i "/^\$db_host\s*=.*/ s//\$db_host = \"localhost\";/" /var/www/html/config.php
sed -i "/^\$db_user\s*=.*/ s//\$db_user = \"ixian\";/" /var/www/html/config.php
sed -i "/^\$db_pass\s*=.*/ s//\$db_pass = \"ixian\";/" /var/www/html/config.php

sed -i "/^\$dlt_host\s*=.*/ s//\$dlt_host = \"$ESCAPED_DLT_URL\";/" /var/www/html/config.php

sed -i "/^\$poolfee\s*=.*/ s//\$poolfee = $POOL_FEE;/" /var/www/html/config.php
sed -i "/^\$poolfee_address\s*=.*/ s//\$poolfee_address = \"$POOL_REWARD_ADDRESS\";/" /var/www/html/config.php
sed -i "/^\$pool_name\s*=.*/ s//\$pool_name = \"$POOL_NAME\";/" /var/www/html/config.php
sed -i "/^\$pool_url\s*=.*/ s//\$pool_url = \"$ESCAPED_POOL_URL\";/" /var/www/html/config.php

mysql -e "CREATE DATABASE ixian"
mysql -e "CREATE USER 'ixian'@'localhost' IDENTIFIED BY 'ixian'"
mysql -e "GRANT ALL PRIVILEGES ON ixian.* TO 'ixian'@'localhost'"
mysql ixian < /opt/Ixian/Ixian-Pool/pool.sql

crontab -l | { cat; echo "* * * * * cd /var/www/html/scripts && /usr/bin/php fetch.php"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * cd /var/www/html/scripts && /usr/bin/php balances.php"; } | crontab -
crontab -l | { cat; echo "0 * * * * cd /var/www/html/scripts && /usr/bin/php pay.php"; } | crontab -