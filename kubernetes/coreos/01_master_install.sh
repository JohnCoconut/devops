#!/bin/bash

master1_IP=10.0.0.61

echo "copy certificate and script"
scp .ssl/ca.pem core@${master1_IP}:~
scp .ssl/apiserver.pem core@${master1_IP}:~
scp .ssl/apiserver-key.pem core@${master1_IP}:~
scp 01_master.sh core@${master1_IP}:~

echo "run master installation"
ssh core@${master1_IP} sudo ./01_master.sh
