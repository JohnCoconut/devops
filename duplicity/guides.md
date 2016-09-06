### Some examples on how to use duplicity

We have two hosts here. One host is duplicity.example.com, and the other backup.example.com. We are backing up data from duplicity.example.com to backup.example.com

#### set up ssh key on host duplicity.example.com to backup data to host backup.example.com

1. on host backup.example.com
```bash
useradd backup
passwd backup
mkdir /data
```

2. on host duplicity.example.com

```bash
ssh-keygen 
ssh-copy-id -i ~/.ssh/id_rsa.pub backup@backup.example.com
```

3. create a directory on host duplicity.example.com
```bash
cp -a /etc /tmp
```

4. backup /tmp/etc folder to /data/dup directory on backup.example.com
```bash
export PASSPHRASE=devops

# using sftp to back up local directoy /tmp/src to remote host backup.example.com
duplicity /tmp/etc sftp://backup@backup.example.com//data/dup

# show lastest backup status
duplicity collection-status sftp://backup@backup.example.com//data/dup

# list files from most recent backup
duplicity list-current-files sftp://backup@backup.example.com//data/dup

# compare files from remote with local files
duplicity verify stfp://backup@backup.example.com//data/dup /tmp/etc
```
