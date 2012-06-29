#!/bin/bash
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install php5
sudo rm -Rf /var/www/html
sudo mkdir -p /var/www/html/ 
cd /var/www/html && sudo wget http://sourceforge.net/projects/flow3/files/latest/download -O flow3.tar.bz2 && sudo tar xjf flow3.tar.bz2 --strip-components=1
sudo chown -R www-data:www-data /var/www/html/
cd /var/www/html && sudo ./flow3 core:setfilepermissions vagrant www-data www-data
sudo cp /vagrant/000-default /etc/apache2/sites-enabled && sudo /etc/init.d/apache2 restart