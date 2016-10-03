#!/bin/bash

master1_IP=10.0.0.61
WORKER_IP=10.0.0.66
WORKER_FQDN=core-node2.example.com

echo "copy certificate and scripts"
scp .ssl/ca.pem core@${WORKER_IP}:~
scp .ssl/${WORKER_FQDN}-worker.pem core@${WORKER_IP}:~
scp .ssl/${WORKER_FQDN}-worker-key.pem core@${WORKER_IP}:~
scp 02_node2.sh core@${WORKER_IP}:~

echo "run node installation"
ssh core@${WORKER_IP} sudo ./02_node2.sh
