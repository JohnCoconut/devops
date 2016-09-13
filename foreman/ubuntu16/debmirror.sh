#!/bin/bash

# https://n40lab.wordpress.com/2016/02/29/installing-cobbler-in-centos-7/
### wget http://sg.archive.ubuntu.com/ubuntu/pool/universe/d/debmirror/debmirror_2.25ubuntu2.tar.xz
### tar Jxf debmirror_2.25ubuntu2.tar.xz
### cp debmirror-2.25ubuntu2/debmirror /usr/local/bin

# install perl modules for debmirror perl script
# yum -y install perl-Compress-Zlib perl-Digest-SHA perl-LockFile-Simple perl-Digest-MD5 perl-Net-INET6Glue perl-LWP-Protocol-https

arch=amd64
section=main,restricted
release=xenial,trusty
server=sg.archive.ubuntu.com
inPath=/ubuntu
proto=http
outPath=/var/www/html/ubuntu

debmirror       --arch=$arch \
                --no-source \
                --section=$section \
                --host=$server \
                --dist=$release \
                --root=$inPath \
                --progress \
                --ignore-release-gpg \
                --no-check-gpg \
                --method=$proto \
                $outPath
