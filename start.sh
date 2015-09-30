#! /bin/bash
#--------------
echo "Staring nginx:"
/usr/sbin/nginx &

echo "Staring ssh"
/usr/sbin/sshd -D