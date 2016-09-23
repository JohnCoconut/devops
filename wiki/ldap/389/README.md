#### 389 installation and configuration guide


#### installation

```bash
yum -y install epel-release
yum -y install 389-ds

# open firewall for ldap and ldaps
firewall-cmd --add-services={ldap,ldaps} --permanent

# open firewall for dirsrv-admin port(the port is chosen manually at setup-ds-admin.pl)

setup-ds-admin.pl
```

