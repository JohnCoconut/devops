#!/bin/bash

# install and enable puppet labs puppet collection repository
yum -y install http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.norach.rpm

# install puppet agent
yum -y install puppet-agent
