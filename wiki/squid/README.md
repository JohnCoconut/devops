#### install squid

```bash
yum -y install squid
systemctl start squid; systemctl enable squid
```

#### configure squid authentication(with mysql database end, md5 hashed password)
install perl modules for perl database access
```bash
yum -y install perl-Digest-MD5 
```


```bash
mysql> create database squid;

mysql> grant select on squid.* to squid@localhost identified by 'squidisgood';

mysql> use squid;

mysql> CREATE TABLE `passwd` (
  `user` varchar(32) NOT NULL default '',
  `password` varchar(35) NOT NULL default '',
  `enabled` tinyint(1) NOT NULL default '1',
  `fullname` varchar(60) default NULL,
  `comment` varchar(60) default NULL,
  PRIMARY KEY  (`user`)
);

mysql> insert into passwd values('squiduser',MD5('squidpwd'),1,'squid user fullname','squid user comment');
```

Edit squid.conf so that authentication against MySQL db works, check `squid -v` for the location of squid helper programs. Look for `--libexecdir` option.

```bash
auth_param basic program /usr/lib64/squid/basic_db_auth \
    --user squiduser --password squidpwd --md5 --persist \
    --dsn "DSN:mysql:host=localhost;port=3306;database=squid"

auth_param basic children 5
auth_param basic realm Web-Proxy
auth_param basic credentialsttl 1 minute
auth_param basic casesensitive off


acl db-auth proxy_auth REQUIRED
http_access allow db-auth
http_access allow localhost
http_access deny all
```
