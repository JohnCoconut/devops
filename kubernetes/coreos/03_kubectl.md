## Build a CoreOS K8s cluster from scratch

<hr>
#### Part Four: set up kubectl

```bash
#!/bin/bash

MASTER_HOST=10.0.0.61
CA_CERT=
ADMIN_CERT=
ADMIN_KEY=

echo "Download kubectl binarys"
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.6/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

echo "Configure kubectl"
kubectl config set-cluster default-cluster --server=https://${MASTER_HOST} --certificate-authority=${CA_CERT}
kubectl config set-credentials default-admin --certificate-authority=${CA_CERT} --client-key=${ADMIN_KEY} --client-certificate=${ADMIN_CERT}
kubectl config set-context default-system --cluster=default-cluster --user=default-admin
kubectl config use-context default-system

echo "Verify kubectl Configuration and Connection"
kubectl get nodes
```

------------------------------------------------------
** References **
  * [https://coreos.com/kubernetes/docs/latest/configure-kubectl.html](https://coreos.com/kubernetes/docs/latest/configure-kubectl.html)
