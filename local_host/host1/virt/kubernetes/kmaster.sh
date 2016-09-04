#!/bin/bash

virt-install \
--name kmaster \
--autostart \
--vcpus 1 \
--memory 2048 \
--os-type linux \
--graphics vnc,listen=0.0.0.0 \
--disk path=/var/lib/libvirt/images/kmaster.qcow2,format=qcow2 \
--location http://10.0.0.2/centos \
--network bridge=br0,mac=52:54:00:00:00:05,model=virtio


#--pxe \
