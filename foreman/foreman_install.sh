#!/bin/bash

# purge data from previous installation
find /etc/puppetlabs/puppet/ssl/ -name "*.pem" -exec rm -f {} \;
find  /var/lib/puppet/ssl -type f -exec rm -f {} \;

# CentOS7.2 host
# allocate at least 5GB memory

# Open firewall to allow traffic
firewall-cmd --permanent --add-port={53/tcp,53/udp,67/udp,68/udp,69/udp,80/tcp,443/tcp,8140/tcp}
firewall-cmd --reload

# Install puppet 4.x with puppet agent and server
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

# Enable the EPEL (Extra Packages for Enterprise Linux) and the Foreman repos:
yum -y install epel-release https://yum.theforeman.org/releases/1.12/el7/x86_64/foreman-release.rpm

# Downloading the installer

yum -y install foreman-installer

# Run foreman installer, change 
# interface name "eth0" ==========> to your own, 
# tftp-servername       ==========> to current it addr
foreman-installer \
  --enable-foreman-proxy \
  --enable-foreman-plugin-remote-execution \
  --enable-foreman-plugin-templates \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername=192.168.0.147 \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth0 \
  --foreman-proxy-dhcp-gateway=192.168.0.1 \
  --foreman-proxy-dhcp-range="192.168.0.101 192.168.0.199" \
  --foreman-proxy-dhcp-nameservers="192.168.0.123" \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface=eth0 \
  --foreman-proxy-dns-zone=wein5.com \
  --foreman-proxy-dns-reverse=0.168.192.in-addr.arpa \
  --foreman-proxy-dns-forwarders=192.168.0.123 \
  --foreman-proxy-foreman-base-url=https://foreman.wein5.com

## if password does not work, run
# foreman-rake permissions:reset

## if foreman node is not registered, run
# systemctl restart puppetserver
