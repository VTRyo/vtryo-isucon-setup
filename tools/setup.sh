#!/bin/sh

function install_slackcat () {
  curl -Lo slackcat https://github.com/bcicen/slackcat/releases/download/1.7.2/slackcat-1.7.2-$(uname -s)-amd64
  sudo mv slackcat /usr/local/bin/
  sudo chmod +x /usr/local/bin/slackcat
  slackcat --configure # interactive
}

function install_alp () {
  wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.zip
  unzip alp_linux_amd64.zip
  mv alp /usr/local/bin/
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
  sudo apt install netdata
}

# read envrionment
source ./.env

# make directory
sudo mkdir /var/log/isucon
chmod 755 /var/log/isucon
#update
sudo apt-get update -y
sudo apt-get remove -y nano

# install profiler
install_alp
install_pt-query-digest
install_netdata

# setup config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
sudo cp ../files/nginx/custom.conf /etc/nginx/nginx.conf

sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.org
sudo cp ../files/mysql/my.cnf /etc/mysql/my.cnf

sudo cp ../files/netdata/netdata.conf /etc/netdata/netdata.conf

# restart service

sudo systemctl restart nginx.service
sudo systemctl restart mysqld.service

# setup slack notify
install_slackcat
