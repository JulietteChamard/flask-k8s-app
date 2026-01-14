#!/bin/sh
configure_metallb_for_minikube() {
  # determine load balancer ingress range
  CIDR_BASE_ADDR="$(minikube ip)"
  INGRESS_FIRST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,3}' OFS='.')"
  INGRESS_LAST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,253}' OFS='.')"
  CONFIG_MAP="apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $INGRESS_FIRST_ADDR - $INGRESS_LAST_ADDR"
  # configure metallb ingress address range
  echo "${CONFIG_MAP}" | kubectl apply -f -
  echo "Ip-address range from $INGRESS_FIRST_ADDR to $INGRESS_LAST_ADDR for internet network or LoadBalancer"
}
#Remove a cluster if still running
minikube delete
minikube start --cpus=2 --memory=4G --addons=metallb --addons=metrics-server --addons=dashboard --cni=bridge --extra-config=kubeadm.pod-network-cidr=10.244.20.0/24 --service-cluster-ip-range=10.64.10.0/24
sleep 20
configure_metallb_for_minikube
echo "Cluster is properly configured"
