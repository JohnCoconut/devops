#### ubuntu 16 provsion with foreman

1. [ubuntu iso image could not be used as foreman installation source](http://projects.theforeman.org/issues/16226), use Ubuntu repos directly 

1. ipxe is broken right now, *don't* use it, remove the template on "Operating System"

2. in ubuntu16 "operating system", set "Major Version" to "16",  "Minor Version" to "04", "Architecture" to "x86_64"

3. cp media-src-url/install/netboot/ubuntu-installer/amd64/linux /var/lib/tftpboot/boot/Ubuntu-16.04-x86_64-linux

4. cp media-src-url/install/netboot/ubuntu-installer/amd64/initrd.gz /var/lib/tftpboot/boot/Ubuntu-16.04-x86_64-initrd.gz

5.

