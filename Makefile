setup:
	./tools/setup.sh

base-profile:
	./tools/serverinfo.sh
	./tools/send_file_slack.sh
