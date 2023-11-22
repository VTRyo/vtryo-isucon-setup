#!/bin/bash

# benchmaker鯖に配置してください。benchmarkerコマンドはマニュアルにて変更してください
if [ $# != 1 ]; then
    echo 引数に対象のIPアドレスを渡してください: $*
    exit 1
fi
read -p "/var/log/nginx/access.log, /var/log/mysql/slow-query.logは削除>しましたか？ (y/n):" YN

if [ "${YN}" = "y" ]; then

        /home/isucon/private_isu.git/benchmarker/bin/benchmarker -u /home/isucon/private_isu.git/benchmarker/userdata -t http://$1

else
        echo "You should do this command:"
        echo "  sudo rm /var/log/nginx/access.log /var/log/mysql/slow-query.log"
        echo "  sudo systemctl restart nginx.service mysqld.service"
        exit 1;
fi
