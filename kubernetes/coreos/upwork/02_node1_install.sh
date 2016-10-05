#!/bin/bash

master1_IP=192.168.0.161
WORKER_IP=192.168.0.164
WORKER_FQDN=core-node1.example.com

echo "copy certificate and scripts"
scp .ssl/ca.pem core@${WORKER_IP}:~
scp .ssl/${WORKER_FQDN}-worker.pem core@${WORKER_IP}:~
scp .ssl/${WORKER_FQDN}-worker-key.pem core@${WORKER_IP}:~
scp 02_node1.sh core@${WORKER_IP}:~

echo "run node installation"
ssh core@${WORKER_IP} sudo ./02_node1.sh
