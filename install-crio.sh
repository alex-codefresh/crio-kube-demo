#!/bin/bash
# Installig crio and its prerequrests
# by https://kubernetes.io/docs/setup/cri/#cri-o


echo "-------\n  Loading Modules\n--------\n"
modprobe -va overlay br_netfilter
cat > /etc/modules-load.d/99-kubernetes-cri.conf <<EOF
overlay
br_netfilter
EOF

echo -e "-------\n  Setup required sysctl params, these persist across reboots\n--------\n"
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system

echo -e "-------\n  Installing cri-o components \n--------\n"
apt-get update
apt-get install -y software-properties-common

add-apt-repository -y ppa:projectatomic/ppa
apt-get update

apt-get install -y cri-o-1.11-stable

systemctl enable crio
systemctl start crio



