#!/bin/bash
multipass launch --name master5 --cpus 2 --mem 2G --disk 15G 18.04
multipass exec master5 -- bash -c 'wget https://packages.cloud.google.com/apt/doc/apt-key.gpg'
multipass exec master5 -- bash -c 'sudo apt-key add apt-key.gpg'
multipass exec master5 -- bash -c 'sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"'
multipass exec master5 -- bash -c 'sudo apt-get update && sudo apt-get install -y apt-transport-https'
# multipass exec master -- bash -c 'curl https://releases.rancher.com/install-docker/18.09.sh | sh'
multipass exec master5 -- bash -c 'sudo curl -fsSL https://get.docker.com -o get-docker.sh'
multipass exec master5 -- bash -c 'sudo sh get-docker.sh'
# Setup daemon.
# multipass transfer daemon.json master:
# multipass exec master -- bash -c 'sudo cp /home/ubuntu/daemon.json /etc/docker/daemon.json'
# multipass exec master -- bash -c 'sudo mkdir -p /etc/systemd/system/docker.service.d'
# Restart docker.
multipass exec master5 -- bash -c 'sudo systemctl daemon-reload'
multipass exec master5 -- bash -c 'sudo systemctl restart docker'
multipass exec master5 -- bash -c 'sudo usermod -aG docker ubuntu'
multipass exec master5 -- bash -c 'sudo apt-get install -y kubelet=1.17.8-00 kubeadm=1.17.8-00 kubectl=1.17.8-00'
multipass exec master5 -- bash -c 'sudo apt-mark hold kubelet kubeadm kubectl'
multipass exec master5 -- bash -c 'sudo swapoff -a'
multipass exec master5 -- bash -c  "sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"
multipass exec master5 -- bash -c 'sudo sysctl net.bridge.bridge-nf-call-iptables=1'
# multipass exec master -- bash -c 'sudo kubeadm init --pod-network-cidr=192.178.0.0/16'
multipass exec master5 -- bash -c 'sudo kubeadm init --kubernetes-version=v1.17.4 --pod-network-cidr=192.178.0.0/16'
multipass exec master5 -- bash -c 'sudo cat /etc/kubernetes/admin.conf' > kubeconfig.yaml
export KUBECONFIG=kubeconfig.yaml
# KUBECONFIG=kubeconfig.yaml kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
KUBECONFIG=kubeconfig.yaml kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "now deploying calico ...."
KUBECONFIG=kubeconfig.yaml kubectl create -f calico.yaml
KUBECONFIG=kubeconfig.yaml kubectl rollout status daemonset calico-node -n kube-system
KUBECONFIG=kubeconfig.yaml kubectl get nodes -o wide
echo "Enjoy the kubeadm made Kubernetes 1.6.x on Multipass"
echo "Now deploying the worker nodes"
