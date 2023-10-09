#! /bin/bash
read -p '/path/to/file/on/docker/container/rootfs: ' src
read -p '/path/to/destination/on/host/rootfs: ' dest
read -p 'docker container ID: ' containerid
pwdtemp=$(pwd)
cd /proc/$(sudo docker inspect --format {{.State.Pid}} ${containerid})/root
cp .${src} ${dest}
cd $pwdtemp
exit