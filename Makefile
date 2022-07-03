setup:
	./tools/setup.sh

base-profile:
	./tools/serverinfo.sh
	./tools/send_file_slack.sh ./tools/serverinfo.txt

# /etc/systemd/systemにあるruby系serviceを指定する
ruby-log:
	journalctl -f -xe -u web-ruby

nginx-log:
	sudo cat /var/log/isucon/access.log alp ltsv | tee "./tools/alp.log"
	./tools/send_text_slack.sh ./tools/alp.log

slow-log:
	sudo pt-query-digest /var/log/isucon/slow.log | tee ./tools/slow.log
	./tools/send_file_slack.sh ./tools/slow.log
