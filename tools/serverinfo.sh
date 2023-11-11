#!/bin/sh

# infomation
echo "======== Hostname ========" >> ./tools/serverinfo.txt
hostname >> ./tools/serverinfo.txt

echo "======== OS Version ========" >> ./tools/serverinfo.txt
lsb_release -a >> ./tools/serverinfo.txt

echo "======== Kernel Info ========" >> ./tools/serverinfo.txt
uname -a >> ./tools/serverinfo.txt

echo "======== CPU Info (Logical) ========" >> ./tools/serverinfo.txt
cat /proc/cpuinfo | grep 'processor' | uniq >> ./tools/serverinfo.txt

echo "======== Mem Info (MB) ========" >> ./tools/serverinfo.txt
free -m >> ./tools/serverinfo.txt
