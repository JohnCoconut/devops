#!/bin/bash

virt-install \
--name foreman \
--autostart \
--vcpus 2 \
--memory 4096 \
--os-type linux \
--os-variant rhel7 \
--graphics vnc,listen=0.0.0.0 \
--location http://10.0.0.2/centos \
--disk path=/var/lib/libvirt/images/foreman.img,format=raw \
--network bridge=br0,mac=52:54:00:00:00:03 \
--extra-args "edd=off console=ttyS0,11520"
#--extra-args "edd=off console=ttyS0,11520 ks=http://10.0.0.2/ks.cfg"
