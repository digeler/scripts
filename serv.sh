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
sh -c 'until ping -c1 leader.mesos;do echo waiting for leader.mesos;sleep 15;done;echo leader.mesos up'


