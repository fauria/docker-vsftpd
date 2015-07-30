# fauria/vsftpd

![docker_logo](https://googledrive.com/host/0B7q6BLMXak9VfkpQY3YzNldlSmtxRTZCMEtEVlhhR3QtMFc3aEYzVzA5YlM5MWw5OXhqV0U/docker_139x115.png)![docker_fauria_logo](https://googledrive.com/host/0B7q6BLMXak9VfkpQY3YzNldlSmtxRTZCMEtEVlhhR3QtMFc3aEYzVzA5YlM5MWw5OXhqV0U/docker_fauria_161x115.png)

This Docker container implements a vsftpd server, with the following features:

 * Centos 7 base image.
 * vsftpd 3.0
 * Virtual users
 * Passive mode
 * Logging to a file or STDOUT.

### Installation from [Docker registry hub](https://registry.hub.docker.com/u/fauria/vsftpd/).

You can download the image with the following command:

```bash
docker pull fauria/vsftpd
```
<!--
### Volumes and variables

NOTE: ADD VOLUMES for files and logs.

If you dont specify a user name through the FTP_USER environment variable at run time, 'admin' will be used by default.

Similarly, if you dont specify a password through FTP_PASS, a 16 characters random string will be used.

You can see this data by inspecting the container logs.

To create a new user, you may follow the this manual steps:

Or, alternatively, use the included script:

ftp_useradd

If you want to share a directory between the host and the container, you have to make sure that the file permissons are properly set.

The owne user id and group id are 14 and 80 respectively. This correspond ftp user and ftp group on the container, but may match something else on the host.
-->
