#!/usr/bin/env bash

# Intended for Ubuntu 14.04 (Trusty)

# Run as root
sudo su

# Update Ubuntu
apt-get update
#
# # Adjust timezone to be Phoenix
# # ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
#
# Apache
echo -e "\n----- Provision: Installing apache...\n"
apt-get install -y apache2 apache2-utils
echo "ServerName localhost" > "/etc/apache2/conf-available/fqdn.conf"
a2enconf fqdn
a2enmod rewrite
a2dissite 000-default.conf

# # echo -e "\n----- Provision: Setup /var/www to point to /vagrant ...\n"
# # rm -rf /var/www
# # ln -fs /vagrant /var/www

# Apache / Virtual Host Setup
echo -e "\n----- Provision: Install Host File...\n"
cp /vagrant/vm_provision/hostfile /etc/apache2/sites-available/project.conf
a2ensite project.conf

# Install Software Properties Common
echo -e "\n----- Provision: Install Software Properties Common...\n"
apt-get -y install software-properties-common python-software-properties

# Add php repository
echo -e "\n----- Provision: Add property repository...\n"
echo | add-apt-repository ppa:ondrej/php

echo -e "\n----- Provision: Update...\n"
apt-get update

# Install PHP7.1
echo -e "\n----- Provision: Install PHP 7.1, PHP Modules and Mysql Driver and other dependencies...\n"
apt-get -y install php7.1 libapache2-mod-php php-mysql php-mbstring php7.1-xml php7.1-zip zip unzip


# Install Mysql
export DEBIAN_FRONTEND="noninteractive"

debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"

apt-get install -y mysql-server-5.6

# Create database
echo -e "\n----- Provision: Create database...\n"
mysql -uroot -psecret -e "DROP DATABASE IF EXISTS db_thegrid;"
# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE db_thegrid /*\!40100 DEFAULT CHARACTER SET utf8 */;"

# If /root/.my.cnf doesn't exist then it'll ask for root password
else
    echo "Please enter root user MySQL password!"
    mysql -uroot -psecret -e "CREATE DATABASE db_thegrid /*\!40100 DEFAULT CHARACTER SET utf8 */;"
fi

# Install Composer
echo -e "\n----- Provision: Install Curl, Git Composer "
apt-get -y install curl git
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo -e "\n----- Provision: Clone Repository...\n"
cd /var/www
rm -rf thegrid
git clone https://github.com/leomarbucud/thegrid

echo -e "\n----- Provision: Copy env file...\n"
cp /vagrant/vm_provision/.env /var/www/thegrid/.env

# Run Composer
echo -e "\n----- Provision: Run Composer...\n"
cd /var/www/thegrid
composer install

# Run Migration
echo -e "\n----- Provision: Run Migration...\n"
php artisan migrate

# Install Laravel passport
echo -e "\n----- Provision: Run Migration...\n"
php artisan passport:install

# Install Redux
echo -e "\n----- Provision: Install Redux...\n"
cd /var/www/thegrid/public
npm install --save redux

echo -e "\n----- Provision: Install Vim...\n"
apt-get -y install vim

echo -e "\n----- Provision: Enable SSL...\n"
a2enmod ssl

echo -e "\n----- Provision: Install Node Server...\n"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get -y install nodejs

echo -e "\n----- Provision: Clone Repository Node Server...\n"
cd /var/www
rm -rf node_server
git clone https://github.com/leomarbucud/node_server

echo -e "\n----- Provision: Install Node Modules...\n"
cd /var/www/node_server
npm install

echo -e "\n----- Provision: Install Nodemon...\n"
npm install nodemon -g

echo -e "\n----- Provision: Start node serven...\n"
nodemon server.js

# Cleanup
apt-get -y autoremove

# Restart Apache
echo -e "\n----- Provision: Restarting Apache...\n"
service apache2 restart
