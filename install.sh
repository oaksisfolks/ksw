#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

cp ./ksw /usr/local/sbin/ksw
chmod 755 /usr/local/sbin/ksw

if ! [[ -d /etc/ksw ]] ; then
    mkdir /etc/ksw
    chmod 644 /etc/ksw
fi

if [[ -f /etc/ksw/ksw.conf ]] ; then
    mv /etc/ksw/ksw.conf /etc/ksw/ksw.conf.old
fi

cp ./ksw.conf /etc/ksw/ksw.conf
chmod 644 /etc/ksw/ksw.conf

cp ./kswd.service /usr/lib/systemd/system/kswd.service
chmod 644 /usr/lib/systemd/system/kswd.service

exit
