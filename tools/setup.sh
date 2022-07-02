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

# rack-profilerで十分かも
# function install_myprofiler () {
#   wget https://github.com/KLab/myprofiler/releases/download/0.2/myprofiler.linux_amd64.tar.gz
#   tar xf myprofiler.linux_amd64.tar.gz
#   sudo mv myprofiler /usr/local/bin/
# }
function install_htop () {
  sudo apt-get install htop
}

# read environment
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

# setup config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
sudo cp ../files/nginx/custom.conf /etc/nginx/nginx.conf

sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.org
sudo cp ../files/mysql/my.cnf /etc/mysql/my.cnf

# setup slack notify
install_slackcat
