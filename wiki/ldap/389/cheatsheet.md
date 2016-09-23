#### cheat sheet

```bash

# dirsrv config file is stored in dse.ldif, which can be found
find /etc/dirsrv -name dse.ldif

# search ldap cn=config
ldapsearch -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:1500 -b "cn=config"

# search, but only show immediate child items(only dn, or dn and cn)
ldapsearch -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:1500 -b "cn=config" dn
ldapsearch -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:1500 -b "cn=config" dn cn

# search with condition, enclose the condition with "()"
ldapsearch -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:1500 -b "cn=plugins,cn=config" "(nsslapd-pluginEnabled=on)" dn cn nsslapd-pluginEnabled

# enable dynamic plugins 
cat > nsslapd-dynamic-plugins.ldif <<EOF
dn: cn=config
changetype: modify
replace: nsslapd-dynamic-plugins
nsslapd-dynamic-plugins: on
EOF
ldapmodify -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:389 -f nsslapd-dynamic-plugins.ldif

# enable "ACL Plugin"
cat > acl.ldif <<EOF
dn: cn=ACL Plugin,cn=plugins,cn=config
changetype: modify
replace: nsslapd-pluginEnabled
nsslapd-pluginEnabled: on
EOF
ldapmodify -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:389 -f acl.ldif

# add new root suffix "dc=example2,dc=com"
cat > root-suffix.ldif << EOF
dn: cn="dc=example2,dc=com",cn=mapping tree,cn=config
changetype: add
objectClass: top
objectClass: extensibleObject
objectClass: nsMappingTree
nsslapd-state: backend
nsslapd-backend: userData
cn: dc=example2,dc=com
EOF
ldapmodify -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:389 -f root-sufix.ldif

# add sub suffix under "dc=example2,dc=com"
cat > groups-sub-suffix.ldif << EOF
dn: cn="ou=groups,dc=example2,dc=com",cn=mapping tree,cn=config
changetype: add
objectClass: top
objectClass: extensibleObject
objectClass: nsMappingTree
nsslapd-state: backend
nsslapd-backend: groupData
nsslapd-parent-suffix: dc=example2,dc=com
cn: ou=groups,dc=example2,dc=com
EOF
ldapmodify -D "cn=directory manager" -x -w mypasswd -H ldap://389.example.com:389 -f groups-sub-suffix.ldif

# default naming context
ldapsearch -D "cn=directory manager" -x -w quantum123 -H ldap://389.example.com:389 -b "" -s base

```
