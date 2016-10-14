#!/bin/bash

dnf -y update

dnf -y install vim bash-completion nginx bind git

dnf -y group install with-optional Virtualization

for SERVICE in nginx named libvirtd; do
	systemctl start $SERVICE
	systemctl enable $SERVICE
done

firewall-cmd --add-service={http,dns,vnc-server} --permanent
firewall-cmd --reload

