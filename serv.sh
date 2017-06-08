#!/bin/sh
echo "Starting dns service restart"
#sleep 20
if ping -c1 leader.mesos
then


   echo Looks like dns is resolving
else
   echo i have no resolve restarting service.....
   systemctl restart dcos-mesos-dns.service
   sleep 20
   echo restarted again

fi
until ping -c1 "leader.mesos;do echo waiting for leader.mesos;sleep 15;done;echo leader.mesos up"

echo ***************working on hv clock now 

systemctl disable systemd-timesyncd

sudo apt-get install ntp ntpdate -y

sudo echo 2dd1ce17-079e-403c-b352-a1921ee207ee > /sys/bus/vmbus/drivers/hv_util/unbind

sudo systemctl stop systemd-timesyncd

sudo hwclock --systohc --utc
sudo ntpdate -s ntp.ubuntu.com
sudo service ntp stop
sudo ntpd -gq
sudo service ntp start
sudo systemctl enable ntp
echo am done
echo checking for timedatectl
timedatectl
