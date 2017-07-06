#!/usr/bin/env bash

# Intended for Ubuntu 13.10 (Saucy)

# Update Ubuntu
apt-get update

# Adjust timezone to be Phoenix
ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime

# Apache
echo "----- Provision: Installing apache..."
apt-get install -y apache2 apache2-utils
echo "ServerName localhost" > "/etc/apache2/conf-available/fqdn.conf"
a2enconf fqdn
a2enmod rewrite

echo "----- Provision: Setup /var/www to point to /vagrant ..."
rm -rf /var/www
ln -fs /vagrant /var/www

# Apache / Virtual Host Setup
echo "----- Provision: Install Host File..."
cp /vagrant/vm_provision/hostfile /etc/apache2/sites-available/project.conf
a2ensite project.conf

# Cleanup unneded packages
apt-get -y autoremove

# Restart Apache
echo "----- Provision: Restarting Apache..."
service apache2 restart