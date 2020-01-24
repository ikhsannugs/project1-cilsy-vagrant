#!/bin/bash
        echo "Menyiapkan instalasi web server"
        sudo apt install software-properties-common
        sudo add-apt-repository -y  ppa:nginx/stable
        sudo apt-get update
        echo "Melakukan Instalasi Web server"
        sudo apt-get install -y nginx php7.2-fpm php7.2-mysql
        echo "Melakukan Instalasi Database Server"
        sudo apt-get install -y mysql-server
        echo "Instalasi Server  Selesai"
	echo "=======================>"
	echo "Setup Aplikasi"
        echo "======================>"
        echo "=====================>"
        echo "Memindahkan data"
        echo "=====================>"
        cd /home/vagrant/project1-cilsy/sosial-media-master
        sudo cp -r * /var/www/html
        sudo cp * /var/www/html
        sudo cp .htaccess /var/www/html
	cd /var/www/html
	sudo mv config.php.bak1 config.php
        echo "====================>"
        echo "edit php.ini"
        echo "====================>"
        cd /etc/php/7.2/fpm
        sudo cp php.ini php.ini.bak
        sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini
        echo "===================>"
        echo "copy file config"
        echo "===================>"
        cd /etc/nginx/sites-available
        sudo mv default default.bak
        sudo cat /home/vagrant/project1-cilsy/nginx/default.lb > /etc/nginx/sites-available/default
        echo "===================>"
        echo "restart service"
        echo "===================>"
        sudo nginx -t
        sudo nginx -s reload
        sudo systemctl restart php7.2-fpm.service
        sudo systemctl restart nginx.service
        echo "====================>"
	echo "setup aplikasi selesai"
	echo "====================>"
	echo "Setup db"
	echo "====================>"
        sudo mysql -u root -e "SELECT user,authentication_string,plugin,host FROM mysql.user;"
        echo "Show Mysql user"
        sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Abcd1234567890-';"
        echo "Append Password Root"
        sudo mysql -u root -p"Abcd1234567890-" -e "FLUSH PRIVILEGES;"
        echo "Flus Privileges"
        sudo mysql -u root -p"Abcd1234567890-" -e "SELECT user,authentication_string,plugin,host FROM mysql.user;"
        echo "Show Mysql User"
        sudo mysql -u root -p"Abcd1234567890-" -e "CREATE USER 'devopscilsy'@'localhost' IDENTIFIED BY '1234567890';"
        echo "Adduser"
        sudo mysql -u root -p"Abcd1234567890-" -e "GRANT ALL PRIVILEGES ON *.* to 'devopscilsy'@'localhost';"
        echo "Add Privileges To New User"
        sudo mysql -u "devopscilsy" -p"1234567890" -e "CREATE DATABASE dbsosmed;"
        echo "Create Database with new user"
        sudo mysql -u "devopscilsy" -p"1234567890" -e "show databases;"
        echo "show database"
        cd /home/vagrant/project1-cilsy/sosial-media-master/
        mysql -u "devopscilsy" -p"1234567890" dbsosmed < dump.sql
        sudo systemctl restart nginx.service
        sudo systemctl restart mysql.service
        sudo systemctl restart php7.2-fpm.service
        echo "==================>"
        echo "instalasi server selesai"
	echo "=================>"
	exit 0

