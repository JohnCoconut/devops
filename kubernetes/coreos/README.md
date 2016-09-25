#### cluster TLS using openssl

machines
* core1 (master,IP=10.0.0.11)
* core2 (node1, IP=10.0.0.12)
* core3 (node2, IP=10.0.0.13)

```bash
MASTER_HOST=10.0.0.11
ETCD_ENDPOINTS=http://10.0.0.11
POD_NETWORK=10.1.0.0/16
SERVICE_IP_RANGE=10.3.0.0/24
K8S_SERVICE_IP=10.3.0.1
DNS_SERVICE_IP=10.3.0.10
 
WORKER_IP=192.168.12.185
WORKER_FQDN=k8s-node001
 
WORKER_IP=192.168.12.186
WORKER_FQDN=k8s-node002
```

generate root certificates authority

```bash
mkdir ~/keys
cd ~/keys
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
```

openssl config
```
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
IP.1 = 10.3.0.1
IP.2 = 10.0.0.11
EOF
```

generate api server key-pari
```bash
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf
```
worker openssl config
```bash
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
```

Generate the Kubernetes Worker Keypairs
```bash
openssl genrsa -out ${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP=${WORKER_IP} openssl req -new -key ${WORKER_FQDN}-worker-key.pem -out ${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config worker-openssl.cnf
WORKER_IP=${WORKER_IP} openssl x509 -req -in ${WORKER_FQDN}-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf
```

Generate the Cluster Administrator Keypair
```bash
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
```
