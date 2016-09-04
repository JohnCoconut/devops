#!/bin/bash

aptitude install qemu-kvm libvirt-bin virtinst

cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet manual

auto br0
iface br0 inet static
        address 10.0.0.2
        netmask 255.255.0.0
        network 10.0.0.0
        broadcast 10.0.255.255
        gateway 10.0.0.1
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
        dns-nameservers 8.8.8.8
EOF
