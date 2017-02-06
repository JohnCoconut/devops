#!/bin/bash

# disable "Safemode rendering" in foreman settings, or template might not work
# disable dhcp on the existing network(ie on router)

firewall-cmd --permanent --add-port={53/tcp,53/udp,67/udp,68/udp,69/udp,80/tcp,443/tcp,8140/tcp}
firewall-cmd --reload

yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install  https://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm

yum -y update

yum -y install foreman-installer

foreman-installer \
  --enable-foreman-proxy \
  --enable-foreman-plugin-remote-execution \
  --enable-foreman-plugin-templates \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername=10.0.0.3 \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth0 \
  --foreman-proxy-dhcp-gateway=10.0.0.1 \
  --foreman-proxy-dhcp-range="10.0.0.2 10.0.0.200" \
  --foreman-proxy-dhcp-nameservers="10.0.0.2" \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface=eth0 \
  --foreman-proxy-dns-zone=example.com \
  --foreman-proxy-dns-reverse=0.10.in-addr.arpa \
  --foreman-proxy-dns-forwarders=10.0.0.2 \
  --foreman-proxy-foreman-base-url=https://foreman.example.com

## if password does not work, run
# foreman-rake permissions:reset

## if foreman node is not registered, run
# systemctl restart puppetserver

# puppet agent --test
