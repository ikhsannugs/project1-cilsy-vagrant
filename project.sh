#!/bin/bash
read -p "Apakah kamu yakin mengnstall webserver ? (Y/n) " pilih;
if echo $pilih | grep -iq "^y"
then
        echo "Menyiapkan instalasi web server"
        sudo apt install software-properties-common
        sudo add-apt-repository -y  ppa:nginx/stable
        sudo apt-get update
        echo "Melakukan Instalasi Web server"
        sudo apt-get install -y nginx php7.2-fpm php7.2-mysql
        echo "Melakukan Instalasi Database Server"
        sudo apt-get install -y mysql-server
        echo "Instalasi Git"
        sudo apt-get install -y git
        echo "Instalasi Server  Selesai"
	echo "=======================>"
	echo "Setup Aplikasi"
        echo "======================>"
        echo "Download Data"
        echo "=====================>"
        cd /home/vagrant
        git clone https://github.com/ikhsannugs/project1-cilsy.git
        echo "=====================>"
        echo "Memindahkan data"
        echo "=====================>"
        cd ~/project1-cilsy/sosial-media-master
        sudo cp -r * /var/www/html
        sudo cp * /var/www/html
        sudo cp .htaccess /var/www/html
	cd /var/www/html
	sudo mv config.php.bak2 config.php
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
        sudo cp ~/project1-cilsy/nginx/default /etc/nginx/sites-available/
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
	read -p "Apakah anda yakin untuk melakukan setup mysql ? (Y/n)" pilih;
        echo "Silahkan Masukkan Password untuk user root sql ?" 
        read -s pass;
        echo "Silahkan Masukkan Nama User anda ?" 
        read user;
        echo "Silahkan Masukkan password user anda ?";
        read -s passusr;
        echo "Silahkan Masukkan Nama Database Anda ?";
        read dbase;
        echo "==================>"
        echo "Create Password Root"
        echo "==================>"
        sudo mysql -u root -e "SELECT user,authentication_string,plugin,host FROM mysql.user;"
        echo "Show Mysql user"
        sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$pass';"
        echo "Append Password Root"
        sudo mysql -u root -p"$pass" -e "FLUSH PRIVILEGES;"
        echo "Flus Privileges"
        sudo mysql -u root -p"$pass" -e "SELECT user,authentication_string,plugin,host FROM mysql.user;"
        echo "Show Mysql User"
        sudo mysql -u root -p"$pass" -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$passusr';"
        echo "Adduser"
        sudo mysql -u root -p"$pass" -e "GRANT ALL PRIVILEGES ON *.* to '$user'@'localhost';"
        echo "Add Privileges To New User"
        sudo mysql -u "$user" -p"$passusr" -e "CREATE DATABASE $dbase;"
        echo "Create Database with new user"
        sudo mysql -u "$user" -p"$passusr" -e "show databases;"
        echo "show database"
        cd /var/www/html
        mysql -u "$user" -p"$passusr" $dbase < dump.sql
        sudo sed -i "s/a1/$user/g" config.php
        sudo sed -i "s/a2/$passusr/g" config.php
        sudo sed -i "s/a3/$dbase/g" config.php
        sudo systemctl restart nginx.service
        sudo systemctl restart mysql.service
        sudo systemctl restart php7.2-fpm.service
        echo "==================>"
        echo "instalasi server selesai"
	echo "=================>"
	exit 0
else
        echo "Instalasi dibatalkan"
        exit 1
fi

