#!/bin/bash

# export env variables
# variable have to be changed
ADVERTISE_IP=10.0.0.64
MASTER_HOST=10.0.0.61
API_SERVERS=https://10.0.0.61
ETCD_ENDPOINTS=http://10.0.0.61:2379
WORKER_FQDN=core-node1.example.com

# vaiable unchanged
DNS_SERVICE_IP=10.3.0.10
K8S_VER=v1.4.0_coreos.2
NETWORK_PLUGIN=

mkdir -p /etc/kubernetes/ssl
mv /home/core*.pem /etc/kubernetes/ssl
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem

cd /etc/kubernetes/ssl/
sudo ln -s ${WORKER_FQDN}-worker.pem worker.pem
sudo ln -s ${WORKER_FQDN}-worker-key.pem worker-key.pem

echo "Networking Configuration"
if [ ! -d /etc/flannel ]; then
    mkdir -p /etc/flannel
fi
cat > /etc/flannel/options.env << EOF
FLANNELD_IFACE=${ADVERTISE_IP}
FLANNELD_ETCD_ENDPOINTS=${ETCD_ENDPOINTS}
EOF

if [ ! -d /etc/systemd/system/flanneld.service.d ]; then
    mkdir -p /etc/systemd/system/flanneld.service.d
fi
cat > /etc/systemd/system/flanneld.service.d/40-ExecStartPre-symlink.conf << EOF
[Service]
ExecStartPre=/usr/bin/ln -sf /etc/flannel/options.env /run/flannel/options.env
EOF

echo "Docker Configuration"
if [ ! -d /etc/systemd/system/docker.service.d ]; then
    mkdir -p /etc/systemd/system/docker.service.d
fi
cat > /etc/systemd/system/docker.service.d/40-flannel.conf << EOF
[Unit]
Requires=flanneld.service
After=flanneld.service
EOF

echo "Create the kubelet Unit"
cat > /etc/systemd/system/kubelet.service << EOF
[Service]
ExecStartPre=/usr/bin/mkdir -p /etc/kubernetes/manifests
ExecStartPre=/usr/bin/mkdir -p /var/log/containers

Environment=KUBELET_VERSION=${K8S_VER}
Environment="RKT_OPTS=--volume var-log,kind=host,source=/var/log \
  --mount volume=var-log,target=/var/log \
  --volume dns,kind=host,source=/etc/resolv.conf \
  --mount volume=dns,target=/etc/resolv.conf"

ExecStart=/usr/lib/coreos/kubelet-wrapper \
  --api-servers=${API_SERVERS} \
  --network-plugin-dir=/etc/kubernetes/cni/net.d \
  --network-plugin=${NETWORK_PLUGIN} \
  --register-node=true \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --hostname-override=${ADVERTISE_IP} \
  --cluster-dns=${DNS_SERVICE_IP} \
  --cluster-domain=cluster.local \
  --kubeconfig=/etc/kubernetes/worker-kubeconfig.yaml \
  --tls-cert-file=/etc/kubernetes/ssl/worker.pem \
  --tls-private-key-file=/etc/kubernetes/ssl/worker-key.pem
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF

echo "Set Up the kube-proxy Pod"
if [ ! -d /etc/kubernetes/manifests ]; then
    mkdir -p /etc/kubernetes/manifests
fi
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
    - --master=https://${MASTER_HOST}
    - --kubeconfig=/etc/kubernetes/worker-kubeconfig.yaml
    - --proxy-mode=iptables
    securityContext:
      privileged: true
    volumeMounts:
      - mountPath: /etc/ssl/certs
        name: "ssl-certs"
      - mountPath: /etc/kubernetes/worker-kubeconfig.yaml
        name: "kubeconfig"
        readOnly: true
      - mountPath: /etc/kubernetes/ssl
        name: "etc-kube-ssl"
        readOnly: true
  volumes:
    - name: "ssl-certs"
      hostPath:
        path: "/usr/share/ca-certificates"
    - name: "kubeconfig"
      hostPath:
        path: "/etc/kubernetes/worker-kubeconfig.yaml"
    - name: "etc-kube-ssl"
      hostPath:
        path: "/etc/kubernetes/ssl"
EOF

echo "Set Up kubeconfig"
cat > /etc/kubernetes/worker-kubeconfig.yaml << EOF
apiVersion: v1
kind: Config
clusters:
- name: local
  cluster:
    certificate-authority: /etc/kubernetes/ssl/ca.pem
users:
- name: kubelet
  user:
    client-certificate: /etc/kubernetes/ssl/worker.pem
    client-key: /etc/kubernetes/ssl/worker-key.pem
contexts:
- context:
    cluster: local
    user: kubelet
  name: kubelet-context
current-context: kubelet-context
EOF

echo "Start Services"
systemctl daemon-reload
systemctl start flanneld
systemctl start kubelet
systemctl start ntpd
systemctl enable flanneld
systemctl enable kubelet
systemctl enable ntpd
