#!/bin/sh

# infomation
echo "======== Hostname ========" >> serverinfo.txt
hostname >> serverinfo.txt

echo "======== OS Version ========" >> serverinfo.txt
lsb_release -a >> serverinfo.txt

echo "======== Kernel Info ========" >> serverinfo.txt
uname -a >> serverinfo.txt

echo "======== CPU Info (Logical) ========" >> serverinfo.txt
cat /proc/cpuinfo | grep 'processor' | uniq >> serverinfo.txt

echo "======== Mem Info (MB) ========" >> serverinfo.txt
free -m >> serverinfo.txt
