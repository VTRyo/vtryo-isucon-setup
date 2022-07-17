#!/bin/bash

function install_slackcat () {
  curl -Lo slackcat https://github.com/bcicen/slackcat/releases/download/1.7.3/slackcat-1.7.3-$(uname -s)-amd64
  sudo mv slackcat /usr/local/bin/
  sudo chmod +x /usr/local/bin/slackcat
}

function install_alp () {
  wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.zip
  unzip alp_linux_amd64.zip
  sudo mv alp /usr/local/bin/
}

function install_pt-query-digest () {
  wget https://github.com/percona/percona-toolkit/archive/3.0.5-test.tar.gz
  tar zxvf 3.0.5-test.tar.gz
  ./percona-toolkit-3.0.5-test/bin/pt-query-digest --version
  sudo mv ./percona-toolkit-3.0.5-test/bin/pt-query-digest /usr/local/bin/pt-query-digest
}

function install_fluentd () {
  # see: https://docs.fluentd.org/installation/install-by-deb#step-1-install-from-apt-repository-1
  # ubuntu 20.04
  curl -fsSL https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-ubuntu-focal.sh | sh

  sudo /opt/calyptia-fluentd/bin/fluent-gem install fluent-plugin-s3
  sudo  /opt/calyptia-fluentd/bin/fluent-gem install fluent-plugin-elasticsearch
}

function install_htop () {
  sudo apt-get install htop
}

function install_netdata() {
  sudo apt install -y netdata
}

function set_git () {
  sudo touch ~/.ssh/authorized_keys
  sudo cp tools/files/ssh_config ~/.ssh/config

  sudo chmod 0600 ~/.ssh/config
  sudo chmod 0600 ~/.ssh/authorized_keys
}

function set_nginx_conf () {
  sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
  sudo cp tools/files/nginx/nginx.conf /etc/nginx/nginx.conf
}

function set_mysql_conf () {
  sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.org
  sudo cp tools/files/mysql/my.cnf /etc/mysql/my.cnf
}

function set_netdata_conf () {
  sudo cp tools/files/netdata/netdata.conf /etc/netdata/netdata.conf
}

# read envrionment
source tools/.env

# make directory
sudo mkdir /var/log/isucon
sudo chmod 755 /var/log/isucon

echo "==============================================="
echo "Create Log output directory! -> /var/log/isucon"
echo "==============================================="

#update
sudo apt-get update -y
sudo apt-get remove -y nano

# install profiler
install_alp

echo "======================================="
echo "install alp! You can analyze access.log"
echo "======================================="

install_pt-query-digest

echo "================================================="
echo "install pt-query-digest! You can analyze slow.log"
echo "================================================="

install_netdata

echo "===================================================="
echo "install netdata! You can see the OS metrics visually"
echo "===================================================="

# setup config
set_nginx_conf

echo "=================="
echo "Copy nginx config!"
echo "=================="

set_mysql_conf

echo "==================="
echo "Copy mysqld config!"
echo "==================="

set_netdata_conf

echo "======================================================================="
echo "Copy netdata config! -> You can access Dashboad. http://`hostname -I`:19999"
echo "======================================================================="

# restart service

sudo systemctl restart nginx.service
sudo systemctl restart mysqld.service

echo "======================================="
echo "restart services"
echo "======================================="

# setup slack notify
install_slackcat
echo "======================================="
echo "install slackcat!"
echo "======================================="

echo "-- finish setup! --"

echo "Check files. if there is no file, it will be output."

if [ ! -e /etc/nginx/nginx.conf ]; then
  echo "nginx.conf, copy failed! 手動でコピーするなどで対応してください"
fi

if [ ! -e  /etc/mysql/my.cnf ]; then
  echo "my.cnf, copy failed! 手動でコピーするなどで対応してください"
fi

if [ ! -e /etc/netdata/netdata.conf ]; then
  echo "netdata.conf, copy failed! 手動でコピーするなどで対応してください"
fi

echo "End file check."

echo "---------------------------- Next Run command! --------------------------------------"
echo "\"slackcat --configure\""
echo "\"ssh-keygen -t rsa\" You have to register that your ssh-keygen's key on github repo!"
echo "-------------------------------------------------------------------------------------"
