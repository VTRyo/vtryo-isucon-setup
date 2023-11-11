#!/bin/bash

cat $1 | notify_slack -c $HOME/.notify_slack.toml
