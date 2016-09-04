#!/bin/bash

virt-install \
--pxe \
--name knode1 \
--autostart \
--vcpus 1 \
--memory 2048 \
--os-type linux \
--graphics vnc,listen=0.0.0.0 \
--disk path=/var/lib/libvirt/images/knode1.qcow2,format=qcow2 \
--network bridge=br0,mac=52:54:00:00:00:06,model=virtio


#--location http://10.0.0.2/centos \
#--pxe \
