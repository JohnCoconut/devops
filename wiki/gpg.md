https://www.gnupg.org/gph/en/manual.html#AEN185

### gpg cheat sheet

```bash
gpg --gen-key

gpg --list-key

gpg --output revoke.asc --gen-revoke john@example.com

gpg --output john.gpg --export john@example.com

gpg --armor --output john.gpg --export john@example.com

gpg --import kate.gpg

gpg --edit-key kate@example.com

fpr 

sign

check

gpg --output doc.gpg --encrypt --recipient john@example.com doc

gpg --output doc --decrypt dock.gpg

gpg --output doc.gpg --sysmmetric doc

gpg --output doc.gpg --sign doc

gpg --output doc --decrypt doc.gpg

gpg --output doc.gpg --clearsign doc

gpg --output doc.sig --detach-sig doc

gpg --edit-key john@example.com

toggle

check

addkey
adduid

key 1
key 2

uid 1
uid 2

delkey
deluid

revkey
revsig

expire
trust

gpg --keyserver certserver.pgp.com --recv-key 0xBB7576AC
pg --keyserver certserver.pgp.com --send-key blake@cyb.org
```
