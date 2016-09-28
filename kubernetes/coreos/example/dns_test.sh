#!/bin/bash

cat > mysql-service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  labels:
    name: mysql
    role: service
  name: mysql-service
spec:
  ports:
    - port: 3306
      targetPort: 3306
  type: NodePort
  selector:
    name: mysql
EOF

kubectl create -f mysql-service.yaml

cat > busybox.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: busybox
    role: master
  name: busybox
spec:
  containers:
    - name: busybox
      image: busybox  
      command:
      - sleep
      - "360000"
EOF

kubectl create -f busybox.yaml

# kubectl exec -i -t busybox sh
# nslookup mysql-service
