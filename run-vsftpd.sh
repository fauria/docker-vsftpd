#!/bin/bash

# If no env var for FTP_USER has been specified, use 'admin':
if [ "$FTP_USER" = "**String**" ]; then
    export FTP_USER='admin'
fi

# If no env var has been specified, generate a random password for FTP_USER:
if [ "$FTP_PASS" = "**Random**" ]; then
    export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
fi

# Do not log to STDOUT by default:
if [ "$LOG_STDOUT" = "**Boolean**" ]; then
    export LOG_STDOUT=''
else
    export LOG_STDOUT='Yes.'
fi

# Create home dir and update vsftpd user db:
mkdir -p "/home/vsftpd/${FTP_USER}"
chown -R ftp:ftp /home/vsftpd/

echo -e "${FTP_USER}\n${FTP_PASS}" > /etc/vsftpd/virtual_users.txt
/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

# Set passive mode parameters:
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
    export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
fi

# Custom exposed options:
vsftpd_conf=/etc/vsftpd/vsftpd.conf
grep -Fq "reverse_lookup_enable=" ${vsftpd_conf} || echo "reverse_lookup_enable=${REVERSE_LOOKUP_ENABLE}" >> ${vsftpd_conf}
grep -Fq "pasv_address="          ${vsftpd_conf} || echo "pasv_address=${PASV_ADDRESS}"                   >> ${vsftpd_conf}
grep -Fq "pasv_max_port="         ${vsftpd_conf} || echo "pasv_max_port=${PASV_MAX_PORT}"                 >> ${vsftpd_conf}
grep -Fq "pasv_min_port="         ${vsftpd_conf} || echo "pasv_min_port=${PASV_MIN_PORT}"                 >> ${vsftpd_conf}
grep -Fq "pasv_addr_resolve="     ${vsftpd_conf} || echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}"         >> ${vsftpd_conf}
grep -Fq "pasv_enable="           ${vsftpd_conf} || echo "pasv_enable=${PASV_ENABLE}"                     >> ${vsftpd_conf}
grep -Fq "file_open_mode="        ${vsftpd_conf} || echo "file_open_mode=${FILE_OPEN_MODE}"               >> ${vsftpd_conf}
grep -Fq "local_umask="           ${vsftpd_conf} || echo "local_umask=${LOCAL_UMASK}"                     >> ${vsftpd_conf}
grep -Fq "xferlog_std_format="    ${vsftpd_conf} || echo "xferlog_std_format=${XFERLOG_STD_FORMAT}"       >> ${vsftpd_conf}

# Get log file path
export LOG_FILE=`grep xferlog_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`

# stdout server info:
if [ ! $LOG_STDOUT ]; then
cat << EOB
	*************************************************
	*                                               *
	*    Docker image: fauria/vsftpd                *
	*    https://github.com/fauria/docker-vsftpd    *
	*                                               *
	*************************************************

	SERVER SETTINGS
	---------------
	· FTP User: $FTP_USER
	· FTP Password: $FTP_PASS
	· Log file: $LOG_FILE
	· Redirect vsftpd log to STDOUT: No.
EOB
else
    /usr/bin/ln -sf /dev/stdout $LOG_FILE
fi

# Run vsftpd:
&>/dev/null /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
