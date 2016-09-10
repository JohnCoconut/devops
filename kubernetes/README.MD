### Kubernetes deployment on CentOS 7.2

kubernetes master: kmaster

kubernetes nodes: knode1 knode2 knode3

======================================================
1. on all hosts: kmaster knode1 knode2 knode3
======================================================

``` bash
cat > /etc/yum.repos.d/docker.repo <<EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

```bash
yum -y install kubernetes etcd flanneld ntp
```


======================================================
2. on kmaster
======================================================

```bash
vim /etc/etcd/etcd.conf

ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
```

```bash
vim /etc/kubernetes/apiserver

KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet_port=10250"
KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
KUBE_API_ARGS=""
```

```bash
systemctl start etcd
```

```bash
etcdctl mk /atomic.io/network/config '{"Network":"10.254.0.0/16"}'
```

```bash
for SERVICES in ntpd etcd kube-apiserver kube-controller-manager kube-scheduler flanneld; do
    systemctl enable $SERVICES
    systemctl restart $SERVICES
    systemctl status $SERVICES 
done
```

======================================================
3. on knode1 knode2 knode3
======================================================

```bash
vim /etc/kubernetes/config

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://kmaster:2379"

# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=false"

# How the replication controller and scheduler find the kube-apiserver
KUBE_MASTER="--master=http://kmaster:8080"
```

```bash
vim /etc/kubernetes/kubelet

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME=""

# location of the api-server
KUBELET_API_SERVER="--api_servers=http://kmaster:8080"

# Add your own!
KUBELET_ARGS=""
```

```bash
vim /etc/sysconfig/flanneld

FLANNEL_ETCD="http://kmaster:2379"
FLANNEL_ETCD_KEY="/atomic.io/network"
```

```bash
for service in ntpd kube-proxy kubelet flanneld docker; do
    systemctl enable $service
    systemctl restart $service
    systemctl status $service 
done
```
