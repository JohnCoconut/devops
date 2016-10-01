#### Windows Active Directory

1. use libvirt to start windows server 2012 R2 installation
```bash
cat > windows.sh << EOF
#!/bin/bash

virt-install \
--name activedirectory \
--cdrom /var/www/html/dvd/win12.iso \
--autostart \
--vcpus 1 \
--memory 2048 \
--os-type windows \
--graphics spice \
--disk path=/var/lib/libvirt/images/ad.qcow2,format=qcow2,bus=ide,size=100 \
--network bridge=br0,mac=52:54:00:00:00:38,model=e1000
EOF
```

2. 

-------------
**References**
  * [https://fedorahosted.org/sssd/wiki/Configuring_sssd_with_ad_server](https://fedorahosted.org/sssd/wiki/Configuring_sssd_with_ad_server)
