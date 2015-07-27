#!/bin/bash

# If no env var for FTP_USER has been specified, use 'admin':
if [ "$FTP_USER" = "**String**" ]; then
    export FTP_USER='admin'
fi

# If no env var has been specified, generate a random password for FTP_USER:
if [ "$FTP_PASS" = "**Random**" ]; then
    export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
fi

# Create home dir and update vsftpd user db:
mkdir -p "/home/vsftpd/${FTP_USER}"
echo -e "${FTP_USER}\n${FTP_PASS}" > /etc/vsftpd/virtual_users.txt
/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

# stdout server info:
cat << EOB
**************************************
*                                    *
*     Docker image: fauria/vsftd     *
*                                    *
**************************************

SERVER INFO
-----------
· FTP User: ${FTP_USER}
· FTP Password: ${FTP_PASS}
· Log file: `grep xferlog_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`

https://github.com/fauria/docker-vsftpd
EOB

# Run vsftpd:
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
