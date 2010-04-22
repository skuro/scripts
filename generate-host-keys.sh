#!/bin/sh
# sshd-key-gen.sh
# post-apply script that properly manages ssh authentication keys
# Install in /var/radmind/postapply

SSHKEYGEN=/usr/bin/ssh-keygen

if [ ! -s /etc/ssh_host_key -o ! -s /etc/ssh_host_key.pub ]; then
    if [ -f /etc/ssh_host_key ]; then
	rm /etc/ssh_host_key
    fi
    if [ -f /etc/ssh_host_key.pub ]; then
	rm /etc/ssh_host_key.pub
    fi
    $SSHKEYGEN -q -t rsa1 -f /etc/ssh_host_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh_host_key"
fi

if [ ! -s /etc/ssh_host_rsa_key -o ! -s /etc/ssh_host_rsa_key.pub ]; then
    if [ -f /etc/ssh_host_rsa_key ]; then
	rm /etc/ssh_host_rsa_key
    fi
    if [ -f /etc/ssh_host_rsa_key.pub ]; then
	rm /etc/ssh_host_rsa_key.pub
    fi
    $SSHKEYGEN -q -t rsa  -f /etc/ssh_host_rsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh_host_rsa_key"
fi

if [ ! -s /etc/ssh_host_dsa_key -o ! -s /etc/ssh_host_dsa_key.pub ]; then
    if [ -f /etc/ssh_host_dsa_key ]; then
	rm /etc/ssh_host_dsa_key
    fi
    if [ -f /etc/ssh_host_dsa_key.pub ]; then
	rm /etc/ssh_host_dsa_key.pub
    fi
    $SSHKEYGEN -q -t dsa -f /etc/ssh_host_dsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh_host_dsa_key"
fi

exit 0

