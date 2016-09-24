#### deploy kube-dns

```bash

KUBE_ROOT=/root/kubernetes

DNS_SERVER_IP=${DNS_SERVER_IP:-"10.254.0.10"}
DNS_DOMAIN=${DNS_DOMAIN:-"cluster.local"}
DNS_REPLICAS=${DNS_REPLICAS:-1}

sed -e "s/\\\$DNS_REPLICAS/${DNS_REPLICAS}/g;s/\\\$DNS_DOMAIN/${DNS_DOMAIN}/g;" "${KUBE_ROOT}/cluster/addons/dns/skydns-rc.yaml.sed" > skydns-rc.yaml
sed -e "s/\\\$DNS_SERVER_IP/${DNS_SERVER_IP}/g" "${KUBE_ROOT}/cluster/addons/dns/skydns-svc.yaml.sed" > skydns-svc.yaml

kubectl --namespace=kube-system create -f skydns-rc.yaml
kubectl --namespace=kube-system create -f skydns-svc.yaml

```
