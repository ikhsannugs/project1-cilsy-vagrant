#!/bin/bash
        echo "Instal Load Balancer"
        sudo apt install software-properties-common
        sudo add-apt-repository -y  ppa:nginx/stable
        sudo apt-get update
        echo "Melakukan Instalasi Web server"
        sudo apt-get install -y nginx
        cd /etc/nginx/sites-available
        sudo mv default default.bak
        sudo cat /home/vagrant/project1-cilsy/nginx/default.master > /etc/nginx/sites-available/default
        echo "restart servoce"
        sudo nginx -t
        sudo nginx -s reload
        sudo systemctl restart nginx.service
        echo "Instal web server selesai"
        exit 0
        

