#!/bin/bash

# Open firewall to allow traffic
firewall-cmd --permanent --add-port={53/tcp,53/udp,67/udp,68/udp,69/udp,80/tcp,443/tcp,8140/tcp}
firewall-cmd --reload

# Install puppet 4.x with puppet agent and server
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

# Enable the EPEL (Extra Packages for Enterprise Linux) and the Foreman repos:
yum -y install epel-release https://yum.theforeman.org/releases/1.12/el7/x86_64/foreman-release.rpm

# Downloading the installer

yum -y install foreman-installer

# Run foreman installer
foreman-installer
