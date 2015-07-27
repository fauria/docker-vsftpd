FROM centos:7
MAINTAINER Fer Uria <fauria@gmail.com>
LABEL Description="vsftpd Docker image based on Centos 7. Supports passive mode and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd fauria/vsftpd" \
	Version="1.0"

RUN yum -y update && yum clean all
RUN yum -y install httpd && yum clean all
RUN yum install -y \
	vsftpd \
	db4-utils \
	db4

ENV FTP_USER **String**
ENV FTP_PASS **Random**

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

EXPOSE 21 21100 21101 21102 21103 21104 21105 21106 21107 21108 21109 21110

CMD ["/usr/sbin/run-vsftpd.sh"]
