export
DB_HOST:=127.0.0.1
DB_PORT:=3306
DB_USER:=
DB_PASS:=
DB_NAME:=
RUBY_SERV:=
PROJECT_ROOT:=/home/isucon

MYSQL_CMD:=mysql -h$(DB_HOST) -P$(DB_PORT) -u$(DB_USER) -p$(DB_PASS) $(DB_NAME)

NGX_LOG:=/var/log/isucon/access.log
MYSQL_LOG:=/var/log/mysql/slow.log



setup:
	./tools/setup.sh

#bench:
#       $(MAKE) restart
#       $(MAKE) clean-log
#       $(MAKE) bench
#       $(MAKE) nginx-log
#       $(MAKE) slow-log

base-profile:
	./tools/serverinfo.sh
	./tools/send_file_slack.sh /home/isucon/tools/serverinfo.txt

restart:
	sudo systemctl restart $(RUBY_SERV)
	sudo systemctl restart nginx
	sudo systemctl restart mysqld

clean-log:
	sudo truncate $(NGX_LOG) --size 0
	sudo truncate $(MYSQL_LOG) --size 0

nginx-log:
	sudo cat $(NGX_LOG) | alp json
	sudo cat $(NGX_LOG) | alp json
	sudo cat $(NGX_LOG) | alp json
	cd $(PROJECT_ROOT); \

slow-log:
	sudo pt-query-digest $(MYSQL_LOG) | tee ./tools/slow.log
	./tools/send_file_slack.sh /home/isucon/tools/tools/slow.log
	cd $(PROJECT_ROOT); \
	git add .; \
	git commit --allow-empty -m "result: `cat ~/tools/slow.log`"
	cd -

slow-on:
	sudo mysql -e "set global slow_query_log_file = '$(MYSQL_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"

slow-off:
	sudo mysql -e "set global slow_query_log = OFF;"

netdata:
	echo "Open your browser -> http://`hostname -I`:19999"
