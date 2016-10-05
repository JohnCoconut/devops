#!/bin/bash

master1_IP="192.168.0.161"
master2_IP="192.168.0.162"
master3_IP="192.168.0.163"
node1_IP="192.168.0.164"
node2_IP="192.168.0.165"
node3_IP="192.168.0.166"
ldbalancer_IP="192.168.0.160"
kubeadm_host_IP="192.168.0.124"
external_host_IP="192.168.0.200"
node1_FQDN="core-node1.example.com"
node2_FQDN="core-node2.example.com"
node3_FQDN="core-node3.example.com"

K8S_SERVICE_IP="10.3.0.1"

key_dir=./.ssl
if [ ! -d $key_dir ]; then
	mkdir $key_dir
fi
cd  $key_dir

echo "generate root CA"
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

cat > openssl.cnf << EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = ${K8S_SERVICE_IP}	# k8s service ip, 1st ip in service_ip_range
IP.2 = ${master1_IP}	# master1
IP.3 = ${master2_IP}	# master2
IP.4 = ${master3_IP}	# master3
IP.5 = ${ldbalancer_IP} 	# loadbalancer
IP.6 = ${kubeadm_host_IP}	# host1 used to manager cluster
IP.7 = ${external_host_IP} 	# external windows IP
EOF

echo "generate api server key"
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

cat > worker-openssl.cnf << 'EOF'
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = $ENV::WORKER_IP
EOF

echo "generate worker key"
declare -A WORKER=([${node1_FQDN}]=${node1_IP} [${node2_FQDN}]=${node2_IP} [${node3_FQDN}]=${node3_IP})
for WORKER_FQDN in "${!WORKER[@]}"; do
openssl genrsa -out ${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP="${WORKER[$WORKER_FQDN]}" openssl req -new -key ${WORKER_FQDN}-worker-key.pem -out ${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config worker-openssl.cnf
WORKER_IP="${WORKER[$WORKER_FQDN]}" openssl x509 -req -in ${WORKER_FQDN}-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf
done

echo "generate kube admin key"
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365

echo "generate certificate file admin.pfx for firefox browser, the pfx file is without password protection"
openssl pkcs12 -export -out admin.pfx -inkey admin-key.pem -in admin.pem -passout pass:
