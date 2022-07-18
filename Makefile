export
DB_HOST:=127.0.0.1
DB_PORT:=3306
DB_USER:=
DB_PASS:=
DB_NAME:=
RUBY_SERV:=
PROJECT_ROOT:=/home/isucon
BENCH_CMD:=./bench -all-addresses 127.0.0.11 -target 127.0.0.11:443 -tls -jia-service-url http://127.0.0.1:4999 > /var/log/isucon/my-bench.txt

MYSQL_CMD:=mysql -h$(DB_HOST) -P$(DB_PORT) -u$(DB_USER) -p$(DB_PASS) $(DB_NAME)

NGX_LOG:=/var/log/isucon/access.log
MYSQL_LOG:=/var/log/isucon/slow.log



setup:
	./tools/setup.sh

bench:
	$(MAKE) restart
	$(MAKE) clean-log
	$(MAKE) bench
	$(MAKE) nginx-log
	$(MAKE) slow-log

base-profile:
	./tools/serverinfo.sh
	./tools/send_file_slack.sh ./tools/serverinfo.txt

restart:
	sudo systemctl restart $(RUBY_SERV)
	sudo systemctl restart nginx
	sudo systemctl restart mysqld

clean-log:
	sudo truncate $(NGX_LOG) --size 0
	sudo truncate $(MYSQL_LOG) --size 0

bench:
	$(BENCH_CMD)

# /etc/systemd/systemにあるruby系serviceを指定する
ruby-log:
	journalctl -f -xe -u $(RUBY_SERV)

nginx-log:
	sudo cat $(NGX_LOG) | alp ltsv | tee "./tools/alp.log"
	./tools/send_text_slack.sh ./tools/alp.log
	cd $(PROJECT_ROOT); \
	git add .; \
	git commit --allow-empty -m "result: `cat ~/tools/alp.log`"
	cd -

slow-log:
	sudo pt-query-digest $(MYSQL_LOG) | tee ./tools/slow.log
	./tools/send_file_slack.sh ./tools/slow.log
	cd $(PROJECT_ROOT); \
	git add .; \
	git commit --allow-empty -m "result: `cat ~/tools/slow.log`"
	cd -

slow-on:
	sudo mysql -e "set global slow_query_log_file = '$(MYSQL_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"

slow-off:
	sudo mysql -e "set global slow_query_log = OFF;"
