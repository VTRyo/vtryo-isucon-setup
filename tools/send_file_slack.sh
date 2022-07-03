#!/bin/bash

cat $1 | slackcat --channel $SLACK_CHANNEL
