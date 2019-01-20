# Kubernetes and Cri-O demo

Why: https://kubic.opensuse.org/blog/2018-09-17-crio-default/


chroot, cgroup, ns: https://itnext.io/chroot-cgroups-and-namespaces-an-overview-37124d995e3d

https://github.com/kubernetes/community/blob/master/contributors/devel/container-runtime-interface.md

https://kubernetes.io/docs/setup/cri/

### Instaling CRI-O
Prerequisites:
https://kubernetes.io/docs/setup/cri/#prerequisites

installation guide: https://github.com/kubernetes-sigs/cri-o#getting-started

apt-add-repository -y ppa:projectatomic/ppa
add-apt-repository -y ppa:alexlarsson/flatpak
apt-get update
```
apt-get install -y \
  btrfs-tools \
  containers-common \
  git \
  golang-go \
  libassuan-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libc6-dev \
  libgpgme11-dev \
  libgpg-error-dev \
  libseccomp-dev \
  libselinux1-dev \
  libostree-dev \
  pkg-config \
  go-md2man \
  runc
```

### Kernel params:
modprobe overlay
modprobe br_netfilter

##### Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

### Install prerequisites
apt-get update
apt-get install software-properties-common

add-apt-repository ppa:projectatomic/ppa
apt-get update

apt-add-repository -y ppa:projectatomic/ppa
add-apt-repository -y ppa:alexlarsson/flatpak
`apt-get install cri-o-1.11-stable`

systemctl enable crio
systemctl start crio


### Install kubelet, kubeadm, kubectl
```
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

### Configure cgroup driver
KUBELET_EXTRA_ARGS=--cgroup-driver=systemd


####
root@master-crio-1:/vagrant# kubectl get nodes
NAME            STATUS   ROLES    AGE     VERSION
master-crio-1   Ready    master   4m19s   v1.13.2
root@master-crio-1:/vagrant# kubectl get pods --all-namespaces
NAMESPACE     NAME                                    READY   STATUS              RESTARTS   AGE
kube-system   coredns-86c58d9df4-gx4ml                0/1     ContainerCreating   0          4m10s
kube-system   coredns-86c58d9df4-ljn9x                0/1     ContainerCreating   0          4m10s
kube-system   etcd-master-crio-1                      1/1     Running             0          3m33s
kube-system   kube-apiserver-master-crio-1            1/1     Running             0          3m19s
kube-system   kube-controller-manager-master-crio-1   1/1     Running             0          3m6s
kube-system   kube-proxy-mls4n                        1/1     Running             0          4m10s
kube-system   kube-scheduler-master-crio-1            1/1     Running             0          3m17s


crio.conf
cni = /opt/cni/bin

