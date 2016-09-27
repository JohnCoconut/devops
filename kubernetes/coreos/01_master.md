## Build a CoreOS K8s cluster from scratch

<hr>
#### Part Two: set up etcd and api-server on core-master* machines


```bash
#!/bin/bash

# set env variables
ADVERTISE_IP=10.0.0.61
POD_NETWORK=10.2.0.0/16
DNS_SERVICE_IP=10.3.0.10
SERVICE_IP_RANGE=10.3.0.0/24
ETCD_SERVER=http://10.0.0.61:2379
ETCD_ENDPOINTS=http://10.0.0.61:2379,http://10.0.0.62:2379,http://10.0.0.63:2379

echo "copy tls keys"
sudo mkdir -p /etc/kubernetes/ssl
sudo scp root@host1:~/coreos_k8s/tls/ca.pem /etc/kubernetes/ssl/ca.pem
sudo scp root@host1:~/coreos_k8s/tls/apiserver.pem /etc/kubernetes/ssl/apiserver.pem
sudo scp root@host1:~/coreos_k8s/tls/apiserver-key.pem /etc/kubernetes/ssl/apiserver-key.pem

sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem


echo "network config"
sudo cat > /etc/flannel/options.env << EOF
FLANNELD_IFACE=${ADVERTISE_IP}
FLANNELD_ETCD_ENDPOINTS=${ETCD_ENDPOINTS}
EOF

sudo cat > /etc/systemd/system/flanneld.service.d/40-ExecStartPre-symlink.conf << EOF
[Service]
ExecStartPre=/usr/bin/ln -sf /etc/flannel/options.env /run/flannel/options.env
EOF

sudo cat > /etc/systemd/system/docker.service.d/40-flannel.conf << EOF
[Unit]
Requires=flanneld.service
After=flanneld.service
EOF

sudo cat > /etc/systemd/system/kubelet.service << EOF
[Service]
ExecStartPre=/usr/bin/mkdir -p /etc/kubernetes/manifests
ExecStartPre=/usr/bin/mkdir -p /var/log/containers

Environment=KUBELET_VERSION=v1.3.6_coreos.0
Environment="RKT_OPTS=--volume var-log,kind=host,source=/var/log \
  --mount volume=var-log,target=/var/log \
  --volume dns,kind=host,source=/etc/resolv.conf \
  --mount volume=dns,target=/etc/resolv.conf"

ExecStart=/usr/lib/coreos/kubelet-wrapper \
  --api-servers=http://127.0.0.1:8080 \
  --register-schedulable=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --hostname-override=${ADVERTISE_IP} \
  --cluster-dns=${DNS_SERVICE_IP} \
  --cluster-domain=cluster.local
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF

echo "Set Up the kube-apiserver Pod"
cat > /etc/kubernetes/manifests/kube-apiserver.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-apiserver
    image: quay.io/coreos/hyperkube:v1.3.6_coreos.0
    command:
    - /hyperkube
    - apiserver
    - --bind-address=0.0.0.0
    - --etcd-servers=${ETCD_ENDPOINTS}
    - --allow-privileged=true
    - --service-cluster-ip-range=${SERVICE_IP_RANGE}
    - --secure-port=443
    - --advertise-address=${ADVERTISE_IP}
    - --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota
    - --tls-cert-file=/etc/kubernetes/ssl/apiserver.pem
    - --tls-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem
    - --client-ca-file=/etc/kubernetes/ssl/ca.pem
    - --service-account-key-file=/etc/kubernetes/ssl/apiserver-key.pem
    - --runtime-config=extensions/v1beta1=true,extensions/v1beta1/networkpolicies=true
    ports:
    - containerPort: 443
      hostPort: 443
      name: https
    - containerPort: 8080
      hostPort: 8080
      name: local
    volumeMounts:
    - mountPath: /etc/kubernetes/ssl
      name: ssl-certs-kubernetes
      readOnly: true
    - mountPath: /etc/ssl/certs
      name: ssl-certs-host
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes/ssl
    name: ssl-certs-kubernetes
  - hostPath:
      path: /usr/share/ca-certificates
    name: ssl-certs-host
EOF

echo "Set Up the kube-proxy Pod:
cat > /etc/kubernetes/manifests/kube-proxy.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: kube-proxy
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-proxy
    image: quay.io/coreos/hyperkube:v1.3.6_coreos.0
    command:
    - /hyperkube
    - proxy
    - --master=http://127.0.0.1:8080
    - --proxy-mode=iptables
    securityContext:
      privileged: true
    volumeMounts:
    - mountPath: /etc/ssl/certs
      name: ssl-certs-host
      readOnly: true
  volumes:
  - hostPath:
      path: /usr/share/ca-certificates
    name: ssl-certs-host
EOF

echo "Set Up the kube-controller-manager Pod"
cat > /etc/kubernetes/manifests/kube-controller-manager.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: kube-controller-manager
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-controller-manager
    image: quay.io/coreos/hyperkube:v1.3.6_coreos.0
    command:
    - /hyperkube
    - controller-manager
    - --master=http://127.0.0.1:8080
    - --leader-elect=true
    - --service-account-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem
    - --root-ca-file=/etc/kubernetes/ssl/ca.pem
    livenessProbe:
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10252
      initialDelaySeconds: 15
      timeoutSeconds: 1
    volumeMounts:
    - mountPath: /etc/kubernetes/ssl
      name: ssl-certs-kubernetes
      readOnly: true
    - mountPath: /etc/ssl/certs
      name: ssl-certs-host
      readOnly: true
  volumes:
  - hostPath:
      path: /etc/kubernetes/ssl
    name: ssl-certs-kubernetes
  - hostPath:
      path: /usr/share/ca-certificates
    name: ssl-certs-host
EOF

echo "Set Up the kube-scheduler Pods"
cat > /etc/kubernetes/manifests/kube-scheduler.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: kube-scheduler
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-scheduler
    image: quay.io/coreos/hyperkube:v1.3.6_coreos.0
    command:
    - /hyperkube
    - scheduler
    - --master=http://127.0.0.1:8080
    - --leader-elect=true
    livenessProbe:
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10251
      initialDelaySeconds: 15
      timeoutSeconds: 1
EOF

echo "Start Services"
sudo systemctl daemon-reload
curl -X PUT -d "value={\"Network\":\"$POD_NETWORK/16\",\"Backend\":{\"Type\":\"vxlan\"}}" "$ETCD_SERVER/v2/keys/coreos.com/network/config"
sudo systemctl start flanneld
sudo systemctl enable flanneld
sudo systemctl start kubelet
sudo systemctl enable kubelet
curl -H "Content-Type: application/json" -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "http://127.0.0.1:8080/api/v1/namespaces"

echo "Job is successful"
```

--------------------
**References**
  * [https://coreos.com/kubernetes/docs/latest/deploy-master.html](https://coreos.com/kubernetes/docs/latest/deploy-master.html)
