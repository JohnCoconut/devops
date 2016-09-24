#### status of kubernetes master on gce 

1. disk info

```bash
admin@kubernetes-master ~ $ lsblk
lsblk: dm-0: failed to get device path
lsblk: dm-0: failed to get device path
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda       8:0    0   10G  0 disk 
|-sda1    8:1    0  5.9G  0 part /mnt/stateful_partition
|-sda2    8:2    0   16M  0 part 
|-sda3    8:3    0    2G  0 part 
|-sda4    8:4    0   16M  0 part 
|-sda5    8:5    0    2G  0 part 
|-sda6    8:6    0  512B  0 part 
|-sda7    8:7    0  512B  0 part 
|-sda8    8:8    0   16M  0 part /usr/share/oem
|-sda9    8:9    0  512B  0 part 
|-sda10   8:10   0  512B  0 part 
|-sda11   8:11   0    8M  0 part 
`-sda12   8:12   0   16M  0 part 
sdb       8:16   0   20G  0 disk /mnt/disks/master-pd

admin@kubernetes-master ~ $ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       1.2G  477M  729M  40% /
devtmpfs        1.9G     0  1.9G   0% /dev
tmp             1.9G   24K  1.9G   1% /tmp
run             1.9G  932K  1.9G   1% /run
shmfs           1.9G     0  1.9G   0% /dev/shm
/dev/sda1       5.7G  2.2G  3.6G  38% /var
/dev/sda8        12M   28K   12M   1% /usr/share/oem
media           1.9G     0  1.9G   0% /media
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
tmpfs           256K     0  256K   0% /mnt/disks
tmpfs           1.0M  124K  900K  13% /var/lib/cloud
overlayfs       1.0M  200K  824K  20% /etc
/dev/sdb         20G   50M   19G   1% /mnt/disks/master-pd

```
1. host network

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 42:01:0a:8c:00:02 brd ff:ff:ff:ff:ff:ff
    inet 10.140.0.2/32 brd 10.140.0.2 scope global dynamic eth0
       valid_lft 85419sec preferred_lft 85419sec
    inet6 fe80::4001:aff:fe8c:2/64 scope link 
       valid_lft forever preferred_lft forever
4: cbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc htb state UP group default qlen 1000
    link/ether 1a:06:da:4d:1b:76 brd ff:ff:ff:ff:ff:ff
    inet 10.123.45.1/30 scope global cbr0
       valid_lft forever preferred_lft forever
    inet6 fe80::44d7:30ff:fe7f:6050/64 scope link 
       valid_lft forever preferred_lft forever
5: veth1af900cb@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue master cbr0 state UP group default 
    link/ether 1a:06:da:4d:1b:76 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::1806:daff:fe4d:1b76/64 scope link 
       valid_lft forever preferred_lft forever
```
1. docker info

```bash
admin@kubernetes-master ~ $ docker info
Containers: 22
 Running: 20
 Paused: 0
 Stopped: 2
Images: 12
Server Version: 1.11.2
Storage Driver: overlay
 Backing Filesystem: extfs
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins: 
 Volume: local
 Network: null host bridge
Kernel Version: 4.4.4+
Operating System: Google Container-VM Image
OSType: linux
Architecture: x86_64
CPUs: 1
Total Memory: 3.612 GiB
Name: kubernetes-master
ID: PILJ:MLAF:V6E7:G6AR:57IU:BYGT:SF47:57QY:G4E2:7BQZ:ALH2:NW2M
Docker Root Dir: /var/lib/docker
Debug mode (client): false
Debug mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No swap limit support

admin@kubernetes-master ~ $ cat /etc/default/docker
DOCKER_OPTS="-p /var/run/docker.pid --iptables=false --ip-masq=false --log-level=warn --registry-mirror=https://asia-mirror.gcr.io "

admin@kubernetes-master ~ $ cat /etc/default/kubelet 
KUBELET_OPTS="--v=2  --allow-privileged=true --babysit-daemons=true --cgroup-root=/ --cloud-provider=gce --cluster-dns=10.0.0.10 --cluster-domain=cluster.local --config=/etc/kubernetes/manifests --kubelet-cgroups=/kubelet --system-cgroups=/system --enable-debugging-handlers=false --hairpin-mode=none --api-servers=https://kubernetes-master --register-schedulable=false --pod-cidr=10.123.45.0/30 --network-plugin-dir=/home/kubernetes/bin --network-plugin=kubenet --reconcile-cidr=false --eviction-hard=memory.available<100Mi --configure-cbr0=true"
```
1. systemd unit files

```bash
admin@kubernetes-master ~ $ systemctl cat docker                   
# /usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-/etc/default/docker
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStartPre=/bin/sh -x -c "if [ ! -s /var/lib/docker/repositories-overlay ]; then rm -f /var/lib/docker/repositories-overlay; fi"
ExecStart=/usr/bin/docker daemon -s overlay --host=fd:// $DOCKER_OPTS
MountFlags=slave
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

[Install]
WantedBy=multi-user.target

admin@kubernetes-master ~ $ systemctl cat kubelet
# /usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes kubelet
Requires=network-online.target
After=network-online.target

[Service]
Restart=always
RestartSec=10
EnvironmentFile=/etc/default/kubelet
ExecStartPre=/bin/mkdir -p /etc/kubernetes/manifests
ExecStart=/usr/bin/kubelet $KUBELET_OPTS

[Install]
WantedBy=multi-user.target

admin@kubernetes-master ~ $ systemctl cat kube-master-installation
# /etc/systemd/system/kube-master-installation.service
[Unit]
Description=Download and install k8s binaries and configurations
After=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStartPre=/bin/mkdir -p /home/kubernetes/bin
ExecStartPre=/bin/mount --bind /home/kubernetes/bin /home/kubernetes/bin
ExecStartPre=/bin/mount -o remount,exec /home/kubernetes/bin
ExecStartPre=/usr/bin/curl --fail --retry 5 --retry-delay 3 --silent --show-error       -H "X-Google-Metadata-Request: True" -o /home/ku
ExecStartPre=/bin/chmod 544 /home/kubernetes/bin/configure.sh
ExecStart=/home/kubernetes/bin/configure.sh

[Install]
WantedBy=kubernetes.target

admin@kubernetes-master ~ $ systemctl cat kube-master-configuration
# /etc/systemd/system/kube-master-configuration.service
[Unit]
Description=Configure kubernetes master
After=kube-master-installation.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/home/kubernetes/bin/configure-helper.sh

[Install]
WantedBy=kubernetes.target


```
1. nodes

```bash
admin@kubernetes-master ~ $ kubectl get nodes
NAME                           STATUS                     AGE
kubernetes-master              Ready,SchedulingDisabled   10m
kubernetes-minion-group-3s5i   Ready                      10m
kubernetes-minion-group-9wg4   Ready                      10m
kubernetes-minion-group-wq6d   Ready                      10m
```
1. namespaces

```bash
admin@kubernetes-master ~ $ kubectl get namespaces
NAME          STATUS    AGE
default       Active    9m
kube-system   Active    9m
```
2. pods

```bash
kubectl get po --all-namespaces
NAMESPACE     NAME                                                 READY     STATUS    RESTARTS   AGE
kube-system   etcd-empty-dir-cleanup-kubernetes-master             1/1       Running   0          4m
kube-system   etcd-server-events-kubernetes-master                 1/1       Running   0          4m
kube-system   etcd-server-kubernetes-master                        1/1       Running   0          4m
kube-system   fluentd-cloud-logging-kubernetes-master              1/1       Running   0          5m
kube-system   fluentd-cloud-logging-kubernetes-minion-group-3s5i   1/1       Running   0          4m
kube-system   fluentd-cloud-logging-kubernetes-minion-group-9wg4   1/1       Running   0          4m
kube-system   fluentd-cloud-logging-kubernetes-minion-group-wq6d   1/1       Running   0          4m
kube-system   heapster-v1.1.0-3249379270-pc13d                     4/4       Running   0          3m
kube-system   kube-addon-manager-kubernetes-master                 1/1       Running   0          4m
kube-system   kube-apiserver-kubernetes-master                     1/1       Running   2          5m
kube-system   kube-controller-manager-kubernetes-master            1/1       Running   0          4m
kube-system   kube-dns-v17.1-8m5ny                                 3/3       Running   0          4m
kube-system   kube-proxy-kubernetes-minion-group-3s5i              1/1       Running   0          4m
kube-system   kube-proxy-kubernetes-minion-group-9wg4              1/1       Running   0          4m
kube-system   kube-proxy-kubernetes-minion-group-wq6d              1/1       Running   0          4m
kube-system   kube-scheduler-kubernetes-master                     1/1       Running   0          4m
kube-system   kubernetes-dashboard-v1.1.1-5h0fe                    1/1       Running   0          4m
kube-system   l7-default-backend-v1.0-nu9u1                        1/1       Running   0          4m
kube-system   l7-lb-controller-v0.7.0-kubernetes-master            1/1       Running   0          5m
kube-system   monitoring-influxdb-grafana-v3-omgp8                 2/2       Running   0          4m
kube-system   node-problem-detector-v0.1-h5dxz                     1/1       Running   0          4m
kube-system   node-problem-detector-v0.1-s7qlz                     1/1       Running   0          4m
kube-system   node-problem-detector-v0.1-td5k5                     1/1       Running   0          4m
kube-system   node-problem-detector-v0.1-v8dto                     1/1       Running   0          4m
```

3. services

```bash
admin@kubernetes-master ~ $ kubectl get svc --all-namespaces
NAMESPACE     NAME                   CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
default       kubernetes             10.0.0.1       <none>        443/TCP             8m
kube-system   default-http-backend   10.0.16.98     <nodes>       80/TCP              7m
kube-system   heapster               10.0.72.51     <none>        80/TCP              7m
kube-system   kube-dns               10.0.0.10      <none>        53/UDP,53/TCP       7m
kube-system   kubernetes-dashboard   10.0.201.190   <none>        80/TCP              7m
kube-system   monitoring-grafana     10.0.153.156   <none>        80/TCP              7m
kube-system   monitoring-influxdb    10.0.129.152   <none>        8083/TCP,8086/TCP   7m
```

4. replication controller

```bash
admin@kubernetes-master ~ $ kubectl get rc --all-namespaces
NAMESPACE     NAME                             DESIRED   CURRENT   AGE
kube-system   kube-dns-v17.1                   1         1         39m
kube-system   kubernetes-dashboard-v1.1.1      1         1         39m
kube-system   l7-default-backend-v1.0          1         1         39m
kube-system   monitoring-influxdb-grafana-v3   1         1         39m
```
4. dns service and rc

```bash
admin@kubernetes-master ~ $ kubectl describe svc kube-dns --namespace=kube-system
Name:			kube-dns
Namespace:		kube-system
Labels:			k8s-app=kube-dns
			kubernetes.io/cluster-service=true
			kubernetes.io/name=KubeDNS
Selector:		k8s-app=kube-dns
Type:			ClusterIP
IP:			10.0.0.10
Port:			dns	53/UDP
Endpoints:		10.244.1.4:53
Port:			dns-tcp	53/TCP
Endpoints:		10.244.1.4:53
Session Affinity:	None
No events.

admin@kubernetes-master ~ $ kubectl describe rc kube-dns-v17.1 --namespace=kube-system
Name:		kube-dns-v17.1
Namespace:	kube-system
Image(s):	asia.gcr.io/google_containers/kubedns-amd64:1.5,asia.gcr.io/google_containers/kube-dnsmasq-amd64:1.3,asia.gcr.io/google_containers/exechealthz-amd64:1.1
Selector:	k8s-app=kube-dns,version=v17.1
Labels:		k8s-app=kube-dns
		kubernetes.io/cluster-service=true
		version=v17.1
Replicas:	1 current / 1 desired
Pods Status:	1 Running / 0 Waiting / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen	LastSeen	Count	From				SubobjectPath	Type		Reason			Message
  ---------	--------	-----	----				-------------	--------	------			-------
  40m		40m		1	{replication-controller }			Normal		SuccessfulCreate	Created pod: kube-dns-v17.1-8m5ny

```
4. test dns

```bash
kubectl create -f mysql-svc.yaml
kubectl create -f busybox-po.yaml

admin@kubernetes-master ~ $ kubectl exec -it busybox sh
/ # nslookup mysql-service
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      mysql-service
Address 1: 10.0.200.120 mysql-service.default.svc.cluster.local
/ # nslookup kubernetes
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.0.0.1 kubernetes.default.svc.cluster.local
/ # nslookup kube-dashboard
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'kube-dashboard'
/ # nslookup heapster
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'heapster'

```
