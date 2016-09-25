#### kubernetes node status

1. host info

```bash
admin@kubernetes-minion-group-3s5i:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0   100G  0 disk 
└─sda1   8:1    0   100G  0 part /
admin@kubernetes-minion-group-3s5i:~$ sudo df -h
Filesystem      Size  Used Avail Use% Mounted on
rootfs           99G  4.2G   90G   5% /
udev             10M     0   10M   0% /dev
tmpfs           750M  692K  750M   1% /run
/dev/sda1        99G  4.2G   90G   5% /
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           1.5G  460K  1.5G   1% /run/shm
cgroup          3.7G     0  3.7G   0% /sys/fs/cgroup
/dev/sda1        99G  4.2G   90G   5% /var/lib/docker/aufs
tmpfs           3.7G   12K  3.7G   1% /var/lib/kubelet/pods/a1892000-8221-11e6-b045-42010a8c0002/volumes/kubernetes.io~secret/default-token-8ig2l
tmpfs           3.7G   12K  3.7G   1% /var/lib/kubelet/pods/a18f6248-8221-11e6-b045-42010a8c0002/volumes/kubernetes.io~secret/default-token-8ig2l
tmpfs           3.7G   12K  3.7G   1% /var/lib/kubelet/pods/a0e74106-8221-11e6-b045-42010a8c0002/volumes/kubernetes.io~secret/default-token-8ig2l
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/a0cbdf4fca39ccedfbf59c23eef8f956d06de483630b19c4da82982823cc752d
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/73a44b6befc349c97b33efb879779d027b7c092733c9417ae8d5115817bfba22
shm              64M     0   64M   0% /var/lib/docker/containers/1ef36d2066e4456387b5e229e105332944f0175759e7d95ecfc3e979e488f817/shm
shm              64M     0   64M   0% /var/lib/docker/containers/7881768bf21b3b2f9979261d0302243ccd018aceba8e487997eb5b5945c1bd42/shm
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/02bef4d0b01f1233d83eeb80be12ee7589c6ae47f9b5d038fc90d7a9caf470b5
shm              64M     0   64M   0% /var/lib/docker/containers/cc9138b924356d545ac0b5367bc56904b81032320ca37e02d50a3c0544bfbe68/shm
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/c69ff30242736406523aff799d9f7fcf765cc26268f9962ab6075855273724ef
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/f97899a0e6cb54181c7fa842c0973e727eb23297497610e6dbd5871ddf69c058
shm              64M     0   64M   0% /var/lib/docker/containers/0cbeecf7a6ec8337c6b8bbf1a09666276ac44c88c9a0aa397a59c21f7b17fd56/shm
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/4ada3cd82a1f0b9d56d11b607da6a086210313810d574f525f21b2dec4450331
shm              64M     0   64M   0% /var/lib/docker/containers/8b0a94c93da7465238bc789c2b3f4930751ca77b60fb1f2f5e4a0f53d4ce6f46/shm
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/77ce91f68d39dc463f10a72f7b6da32815e7f33a714177e51bc40429cef527a8
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/6f6c1279ab9e14f1952c36eff018941fba56afd6f589f75c5dda3c0b20835ab3
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/22a16944745501e86280840e9d4d17ae6286465191a904c7279f41ff8cd28fd1
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/747ab7161b966a45beb389fc7965a2718ae82a8b4dac057f002f230a7c49763f
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/044f7c708dbd8aa38f7c488d9e6e78d8dfeb62cafd3ade2045cedea05e905cbb
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/97d96b49ac1a3dc79de7b29d41939cc6ab383e1b0a30c3fbf171422185d2236b
none             99G  4.2G   90G   5% /var/lib/docker/aufs/mnt/bab22e824246ebd60b4c49fabb1bacbb7ec15dd40880478d16b2e2f3b2b504b9

admin@kubernetes-minion-group-3s5i:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc mq state UP qlen 1000
    link/ether 42:01:0a:8c:00:04 brd ff:ff:ff:ff:ff:ff
    inet 10.140.0.4/32 brd 10.140.0.4 scope global eth0
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 02:42:3b:d3:61:08 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
5: cbr0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1460 qdisc htb state UP qlen 1000
    link/ether 36:57:58:69:ab:5f brd ff:ff:ff:ff:ff:ff
    inet 10.244.1.1/24 scope global cbr0
       valid_lft forever preferred_lft forever
6: vethe80dbed8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue master cbr0 state UP 
    link/ether 86:14:32:8b:7e:6d brd ff:ff:ff:ff:ff:ff
7: veth176fc175: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue master cbr0 state UP 
    link/ether 36:57:58:69:ab:5f brd ff:ff:ff:ff:ff:ff
8: veth7e3b5281: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue master cbr0 state UP 
    link/ether d2:7c:a8:2f:38:da brd ff:ff:ff:ff:ff:ff

root@kubernetes-minion-group-3s5i:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.140.0.1      0.0.0.0         UG    0      0        0 eth0
10.140.0.1      0.0.0.0         255.255.255.255 UH    0      0        0 eth0
10.244.1.0      0.0.0.0         255.255.255.0   U     0      0        0 cbr0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0

```

2. systemd

node machines runs on Debian 7.11 with sysVinit

```bash
root@kubernetes-minion-group-3s5i:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Debian
Description:	Debian GNU/Linux 7.11 (wheezy)
Release:	7.11
Codename:	wheezy
```

3. docker

```bash
root@kubernetes-minion-group-3s5i:~# docker info
Containers: 13
 Running: 13
 Paused: 0
 Stopped: 0
Images: 12
Server Version: 1.11.2
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 93
 Dirperm1 Supported: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins: 
 Volume: local
 Network: null host bridge
Kernel Version: 3.16.0-4-amd64
Operating System: Debian GNU/Linux 7 (wheezy)
OSType: linux
Architecture: x86_64
CPUs: 2
Total Memory: 7.324 GiB
Name: kubernetes-minion-group-3s5i
ID: L5VM:GQXP:GNUA:62LV:M6JB:NBI3:2VB3:YOLE:NGFN:EV5C:JV4C:IN7Z
Docker Root Dir: /var/lib/docker
Debug mode (client): false
Debug mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No swap limit support
WARNING: No kernel memory limit support
WARNING: No cpu cfs quota support
WARNING: No cpu cfs period support

root@kubernetes-minion-group-3s5i:~# ps -ef | grep docker
root      3201     1  1 06:38 ?        00:01:25 /usr/bin/docker daemon -p /var/run/docker.pid -s aufs --registry-mirror=https://asia-mirror.gcr.io --iptables=false --ip-masq=false --log-level=warn
root      3206  3201  0 06:38 ?        00:00:00 docker-containerd -l /var/run/docker/libcontainerd/docker-containerd.sock --runtime docker-runc --start-timeout 2m
root      3469  3444  0 06:38 ?        00:00:00 /bin/bash /usr/sbin/docker-checker.sh
```

4. kubelet

```bash
root@kubernetes-minion-group-3s5i:~# ps -ef | grep kube
root      3468  3444  0 06:38 ?        00:00:00 /bin/bash /usr/sbin/kubelet-checker.sh
root      3501     1  1 06:38 ?        00:01:09 /usr/local/bin/kubelet --api-servers=https://kubernetes-master --enable-debugging-handlers=true --cloud-provider=gce --config=/etc/kubernetes/manifests --allow-privileged=True --v=2 --cluster-dns=10.0.0.10 --cluster-domain=cluster.local --configure-cbr0=true --cgroup-root=/ --system-cgroups=/system --network-plugin=kubenet --reconcile-cidr=true --hairpin-mode=promiscuous-bridge --runtime-cgroups=/docker-daemon --kubelet-cgroups=/kubelet --babysit-daemons=true --eviction-hard=memory.available<100Mi
root      3754  3706  0 06:39 ?        00:00:00 /bin/sh -c kube-proxy --master=https://kubernetes-master --kubeconfig=/var/lib/kube-proxy/kubeconfig  --cluster-cidr=10.244.0.0/14 --resource-container="" --v=2  1>>/var/log/kube-proxy.log 2>&1
root      3769  3754  0 06:39 ?        00:00:02 kube-proxy --master=https://kubernetes-master --kubeconfig=/var/lib/kube-proxy/kubeconfig --cluster-cidr=10.244.0.0/14 --resource-container= --v=2
root      4406  4391  0 06:40 ?        00:00:01 /kube-dns --domain=cluster.local. --dns-port=10053
root      4693  4678  0 06:40 ?        00:00:03 /exechealthz -cmd=nslookup kubernetes.default.svc.cluster.local 127.0.0.1 >/dev/null -port=8080 -quiet

admin@kubernetes-minion-group-agmu:~$ sudo cat /var/lib/kube-proxy/kubeconfig
apiVersion: v1
kind: Config
users:
- name: kube-proxy
  user:
    token: b5aAaS0JmJKriQyZ194dY6biIVuImf8x
clusters:
- name: local
  cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURZakNDQWtxZ0F3SUJBZ0lKQU9vdTlqZHN4bjcxTUEwR0NTcUdTSWIzRFFFQkN3VUFNQ1V4SXpBaEJnTlYKQkFNVUdqRXdOQzR4T1RrdU1UYzNMakl4TjBBeE5EYzBOemsyTWpjd01CNFhEVEUyTURreU5UQTVNemMxTUZvWApEVEkyTURreU16QTVNemMxTUZvd0pURWpNQ0VHQTFVRUF4UWFNVEEwTGpFNU9TNHhOemN1TWpFM1FERTBOelEzCk9UWXlOekF3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRREgwRkFUT0RCMnN1K0UKOFhoMmR0dEo1OXFLWkFCSDY2YmZJRUhsQUtvcVRMMWNaVFZ2NWVvejFyeEFHc3NXN3g1b240ejNVN0x5cGFOUQozT3lOZkttMTFMSTVwQ1MyU3BLK0dVZDFKYVYzaU9rSVNtWXI4bXBJWlM4dS9UTGoyVjd6YVZXb1FncnYwNGRCCnlIYkRDbmdMRDBVWDRUcHZEZnArMHJzWCtWTDVYRTdvTzVwQ2J2RXF5UzM5dmJxZFRNeHBUajk3Wm5JOGw5d3MKRFE2Z0NPTVFjczhLbkxGTWRmWlh0bTk0Qk9KOEtNWWNraGJNTFpKaGNZVEh3V0Uvc3hCZGVSa2pmOThTeGcwTQpaVkxzZDFBdldlWXYyV2JoWEkzNnpOaVMvYlZJbVZUQldBZVJsKzI1Qk9kWHFYcmNmYkF4STJjcFk4RU52T2czCjduaEdFbFVqQWdNQkFBR2pnWlF3Z1pFd0hRWURWUjBPQkJZRUZFYmVvVHl5eDBzazR5bHV4RTlHMlRHQmVGbEcKTUZVR0ExVWRJd1JPTUV5QUZFYmVvVHl5eDBzazR5bHV4RTlHMlRHQmVGbEdvU21rSnpBbE1TTXdJUVlEVlFRRApGQm94TURRdU1UazVMakUzTnk0eU1UZEFNVFEzTkRjNU5qSTNNSUlKQU9vdTlqZHN4bjcxTUF3R0ExVWRFd1FGCk1BTUJBZjh3Q3dZRFZSMFBCQVFEQWdFR01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2tGUEVTcncydzg4M3QKMWJ2UERDRHNrNWpDc09uTVRDeFBhRHoxb0FTNTNhWEFKdFU2a01mK2x1MVF2dnZSazVMeFJhbU5UOFNTT2hxYgpZSGRyYkRZVGw3cEY5NkprZW85dWxUTmRCWHFCZW1zQzVmY0NleDNYbVM1Szl5eFhGOGFKUWh2UlZhS3Fpd0JjCjRXbWJqVnQ2dGdWaXJHQ3gwS1FYL2x5amZrODJOVnk0L1lVak1PeHN0dUtRWWl2QmJWTkdxMUZkbVkyTm1FMm8KL0lWNXZ6a2JVYkV3b3d5aWRZNzg1Qm9BajhkWVFtYnRBeUVtZEIwS3NoQnJCcys0a3krTm9qNENPa3BkUWlVMQo1T0ZMcThEREZrdDAzUjZ2YlZTRy8zN2dtdGQxM0U3dFAwSjdKQ2FVK3FXMkN3bVNTWTVYNG1wWkJjU2xVa0NvCjY5aklOTzlkCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
contexts:
- context:
    cluster: local
    user: kube-proxy
  name: service-account-context
current-context: service-account-context
```
