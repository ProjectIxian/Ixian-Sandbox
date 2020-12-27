#!/bin/bash -e
if [ $# -ne 4 ]; then
	echo "Setup requires 4 parameters"
  exit 1
fi

URL=$1
BRANCH=$2
SHA=$3
DLT_URL=$4
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

echo "Fetching Ixian-Explorer"
git clone -b "$BRANCH" "$URL/Ixian-Explorer.git"

cp -R /opt/Ixian/Ixian-Explorer/. /var/www/html/
rm /var/www/html/index.html

sed -i "/^\$db_host\s*=.*/ s//\$db_host = \"localhost\";/" /var/www/html/config.php
sed -i "/^\$db_user\s*=.*/ s//\$db_user = \"explorer01\";/" /var/www/html/config.php
sed -i "/^\$db_pass\s*=.*/ s//\$db_pass = \"explorer01\";/" /var/www/html/config.php

sed -i "/^\$dlt_host\s*=.*/ s//\$dlt_host = \"$ESCAPED_DLT_URL\";/" /var/www/html/config.php

mysql -e "CREATE DATABASE explorer01"
mysql -e "CREATE USER 'explorer01'@'localhost' IDENTIFIED BY 'explorer01'"
mysql -e "GRANT ALL PRIVILEGES ON explorer01.* TO 'explorer01'@'localhost'"
mysql explorer01 < /opt/Ixian/Ixian-Explorer/explorer.sql

crontab -l | { cat; echo "*/1 * * * * cd /var/www/html/internal && /usr/bin/php fetchstatus.php > /dev/null"; } | crontab -
crontab -l | { cat; echo "*/1 * * * * cd /var/www/html/internal && /usr/bin/php sync.php > /dev/null"; } | crontab -
