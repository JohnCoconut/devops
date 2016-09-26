## Build a CoreOS K8s cluster from scratch

<hr>
#### Part one: set up TLS certificates with OpenSSL

1. To create a `production-like` cluster, we set up 7 machines, 3 of them running etcd+master, 3 of them running nodes, and 1 as load balancer.
  * core-master1 	(IP=10.0.0.61)
  * core-master2 	(IP=10.0.0.62)
  * core-master3 	(IP=10.0.0.63)
  * core-node1		(IP=10.0.0.64)
  * core-node2 		(IP=10.0.0.65)
  * core-node3		(IP=10.0.0.66)
  * core-loadbalancer 	(IP=10.0.0.60)
  *  MASTER_HOST	=		10.0.0.61 10.0.0.62 10.0.0.63
  *  ETCD_ENDPOINTS	=		10.0.0.61 10.0.0.62 10.0.0.63
  *  POD_NETWORK	=		10.2.0.0/16
  *  SERVICE_IP_RANGE	=		10.3.0.0/24
  *  K8S_SERVICE_IP	=		10.3.0.1
  *  DNS_SERVICE_IP	=		10.3.0.10

---------------------------------------------------------------

**copy the whole bash script below to generate certificates**

```bash
#!/bin/bash
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
IP.1 = 10.3.0.1 	# k8s service ip, first ip in service_ip_range
IP.2 = 10.0.0.61	# master1
IP.3 = 10.0.0.62	# master2
IP.4 = 10.0.0.63	# master3
IP.5 = 10.0.0.60	# loadbalancer
IP.6 = 10.0.0.2		# host1 used to manager cluster
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
declare -A WORKER=(["core-node1.example.com"]="10.0.0.64" ["core-node2.example.com"]="10.0.0.65" ["core-node3.example.com"]="10.0.0.66")
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
```

-----------------------------------------------------------
References:
  * [https://coreos.com/kubernetes/docs/latest/openssl.html](https://coreos.com/kubernetes/docs/latest/openssl.html)
  * [http://blog.lwolf.org/post/migrate-infrastructure-to-kubernetes-building-baremetal-cluster/](http://blog.lwolf.org/post/migrate-infrastructure-to-kubernetes-building-baremetal-cluster/)
  * Hash table is used here(only available in bash 4.x). See this [stackoverflow answer](http://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash/3467959#3467959) if you are not sure how to use it in bash.
