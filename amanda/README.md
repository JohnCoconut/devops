#### amanda deployment guide

check this error: [https://forums.zmanda.com/showthread.php?2331-dumptype-parameter-expected](https://forums.zmanda.com/showthread.php?2331-dumptype-parameter-expected)

two machines

one host to be backed up: amanda@example.com

one backup server: backup@example.com


on host amanda@example.com

```bash
yum -y install epel-release
yum -y install amanda-server xinetd
systemctl start xinetd; systemctl enable xinetd
```

on host backup@example.com
```bash
yum -y install epel-release
yum -y install amanda-client xinetd
mkdir /var/lib/amanda/gnutar-lists
```
amtape John show
amtape 
