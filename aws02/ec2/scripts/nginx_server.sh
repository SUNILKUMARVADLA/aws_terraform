#!/bin/bash
sudo apt update && sudo apt-get upgrade
sudo apt install nginx -y
sudo systemctl stop nginx
sudo systemctl start nginx