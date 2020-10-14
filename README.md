# Multi-Node Kubernetes 1.17.4 with kubeadm on local multipass ubuntu 18.04 cloud with Docker

These simple scripts deploy a multi-node Kubernetes 1.17.4 with kubeadm on multipass VMs with Docker on your local machine in about 6 minutes, depending on your internet speed.

## About Multipass

https://multipass.run/

## Prerequsists

You need kubectl and multipass installed on your laptop.

### Install multipass (on MacOS Catalina or Linux)

Get the latest Multipass here:

https://github.com/CanonicalLtd/multipass/releases

## Installation (3 node with docker)

Deploy the master node, 2 worker nodes and join the worker nodes into the cluster step by step:

```bash
./1-deploy-kubeadm-master.sh
./2-deploy-kubeadm-nodes.sh
./3-kubeadm_join_nodes.sh
```

or deploy with a single command:

```bash
./deploy.sh
```

You should get something similar to this at the end:

```bash
NAME      STATUS   ROLES    AGE     VERSION
master    Ready    master   8m55s   v1.17.0
worker1   Ready    node     3m45s   v1.17.0
worker2   Ready    node     3m24s   v1.17.0
############################################################################
Enjoy and learn to love learning :-)
Total runtime in minutes was: 06:30
############################################################################
```

## Copy the locally created kubeconfig files to be avaibale system wide

```bash
cp  kubeconfig.yaml /Users/xxxxxxx/.kube/config
```

## Install MetalLB

```bash
./install-metal-lb.sh
```

### Setting up Traefik

```bash
kubectl apply -f configmap.yml
kubectl create -f traefik.yaml
kubectl apply -f rbac.yml
kubectl get pods -n kube-system | grep traefik
# you should see a line that looks like the following
traefik-ingress-controller-68c5fbccbd-5kjvw   1/1     Running
```

## Troubleshooting

Note: we're using Calico here, if 192.178.0.0/16 is already in use within your network you must select a different pod network CIDR, replacing 192.178.0.0/16 in the kubeadm init command in `./1-deploy-kubeadm-master.sh` script as well as in the `calico.yaml` file provided in this repo.

## Cleanup

```bash
./cleanup.sh
```

## Blog post

A related blog post which i heavily refered to
https://blog.kubernauts.io/simplicity-matters-kubernetes-1-16-fffbf7e84944




