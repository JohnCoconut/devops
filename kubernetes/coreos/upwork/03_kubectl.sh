#!/bin/bash

MASTER_HOST=192.168.0.161

CA_CERT=.ssl/ca.pem
ADMIN_CERT=.ssl/admin.pem
ADMIN_KEY=.ssl/admin-key.pem
$KUBECTL_VER=v1.4.0

echo "Download v1.4.0 kubectl binarys"
curl -O https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

echo "Configure kubectl"
kubectl config set-cluster default-cluster --server=https://${MASTER_HOST} --certificate-authority=${CA_CERT}
kubectl config set-credentials default-admin --certificate-authority=${CA_CERT} --client-key=${ADMIN_KEY} --client-certificate=${ADMIN_CERT}
kubectl config set-context default-system --cluster=default-cluster --user=default-admin
kubectl config use-context default-system

echo "ensure bash-completion is installed"
yum -y install bash-completion

echo "set bash auto-completion"
kubectl completion bash > /etc/bash_completion.d/kubectl

echo "Verify kubectl Configuration and Connection"
kubectl get nodes
