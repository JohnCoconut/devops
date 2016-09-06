```bash

#!/bin/bash
export PASSPHRASE=(insert your value here)
export FTP_PASSWORD=(insert your value here)

# doing a monthly full backup (1M)
duplicity --full-if-older-than 1M /etc ftp://(insert your FTP server here)/etc
# exclude /var/tmp from the backup
duplicity --full-if-older-than 1M --exclude /var/tmp /var ftp://(insert your FTP server here)/var
duplicity --full-if-older-than 1M /root ftp://(insert your FTP server here)/root

# cleaning the remote backup space (deleting backups older than 6 months (6M, alternatives would 1Y fo 1 year etc.)
duplicity remove-older-than 6M --force ftp://(insert your FTP server here)/etc
duplicity remove-older-than 6M --force ftp://(insert your FTP server here)/var
duplicity remove-older-than 6M --force ftp://(insert your FTP server here)/root

unset PASSPHRASE
unset FTP_PASSWORD

```
