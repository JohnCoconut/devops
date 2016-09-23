#### ubuntu 14(trusty), 16(xenial) provsion with foreman

1. [ubuntu iso image could not be used as foreman installation source](http://projects.theforeman.org/issues/16226), use Ubuntu repos directly 

2. foreman preseed template does not allow ssh root login, add this to finish template

```bash
/bin/sed -i "s/^PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/ssd_config
```

3. ssh session does not terminate properly, install "libpam-systemd" package in provision template

```bash
d-i pkgsel/include string libpam-systemd
```

4. To synchronize online repo to local directory, please use debmirror perl script

