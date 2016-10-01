#!/bin/bash
core-master1_IP=10.0.0.61
core-master2_IP=10.0.0.62
core-master3_IP=10.0.0.63
core-node1_IP=10.0.0.64
core-node2_IP=10.0.0.65
core-node3_IP=10.0.0.66
core-ldbalancer_IP=10.0.0.60
kubectl_admin_IP=10.0.0.2
# MASTER_HOST=10.0.0.61 10.0.0.62 10.0.0.63
# ETCD_ENDPOINTS=10.0.0.61 10.0.0.62 10.0.0.63
POD_NETWORK=10.2.0.0/16
SERVICE_IP_RANGE=10.3.0.0/24
K8S_SERVICE_IP=10.3.0.1
DNS_SERVICE_IP=10.3.0.10

# generate root CA
key_dir=~/coreos_k8s/tls
if [ -d $key_dir ]; then
	mkdir $key_dir
fi
cd  $key_dir
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
IP.1 = ${K8S_SERVICE_IP} 	# k8s service ip, first ip in service_ip_range
IP.2 = ${core-master1_IP}	# master1
IP.3 = ${core-master2_IP}	# master2
IP.4 = ${core-master3_IP}	# master3
IP.5 = ${core-ldbalancer_IP} 	# loadbalancer
IP.6 = ${kubectl_admin_IP}	# host1 used to manager cluster
IP.7 = ${windows_IP}		# access from windows host
EOF

# generate api server key
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

cat > worker-openssl.cnf << EOF
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

# generate worker key
declare -A WORKER=(["core-node1.example.com"]="${core-node1_IP}" ["core-node2.example.com"]="${core-node2_IP}" ["core-node3.example.com"]="${core-node3_IP}")
for WORKER_FQDN in "${!WORKER[@]}"; do
WORKER_IP="${WORKER[$WORKER_FQDN]}"
openssl genrsa -out ${WORKER_FQDN}-worker-key.pem 2048
openssl req -new -key ${WORKER_FQDN}-worker-key.pem -out ${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config worker-openssl.cnf
openssl x509 -req -in ${WORKER_FQDN}-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf
done

# generate kube admin key
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
echo "generate certificate file admin.pfx for firefox browser, the pfx file is without password protection"
openssl pkcs12 -export -out admin.pfx -inkey admin-key.pem -in admin.pem -passout pass:
