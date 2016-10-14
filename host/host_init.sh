#!/bin/bash

dnf -y update

dnf -y install vim bash-completion nginx bind git

dnf -y group install with-optional Virtualization

for SERVICE in nginx named libvirtd virtlogd; do
	systemctl start $SERVICE
	systemctl enable $SERVICE
done

firewall-cmd --add-service={http,dns,vnc-server} --permanent
firewall-cmd --reload

nmcli c add type bridge ifname br0 con-name br0
nmcli c add type bridge-slave ifname eno1 con-name br0-slave master br0
nmcli c mod br0 ipv4.addresses 10.0.0.2/16 ipv4.gateway 10.0.0.1 ipv4.dns 10.0.0.2  ipv4.method manual
nmcli c reload
systemctl restart network
