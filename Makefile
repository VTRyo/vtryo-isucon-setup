export
DB_HOST:=127.0.0.1
DB_PORT:=3306
DB_USER:=
DB_PASS:=
DB_NAME:=
RUBY_SERV:=


MYSQL_CMD:=mysql -h$(DB_HOST) -P$(DB_PORT) -u$(DB_USER) -p$(DB_PASS) $(DB_NAME)

NGX_LOG:=/var/log/isucon/access.log
MYSQL_LOG:=/var/log/slow.log



setup:
	./tools/setup.sh

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

# /etc/systemd/systemにあるruby系serviceを指定する
ruby-log:
	journalctl -f -xe -u $(RUBY_SERV)

nginx-log:
	sudo cat $(NGX_LOG) alp ltsv | tee "./tools/alp.log"
	./tools/send_text_slack.sh ./tools/alp.log

slow-log:
	sudo pt-query-digest $(MYSQL_LOG) | tee ./tools/slow.log
	./tools/send_file_slack.sh ./tools/slow.log
