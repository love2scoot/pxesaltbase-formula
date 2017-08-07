#!/bin/bash

apt-get install -y openssh-server

if ( grep "^PermitRootLogin yes" /etc/ssh/sshd_config ) # Format with root SSH enabled
then
	echo ""
	echo "No change required: SSH appears to already be enabled for root"
	echo ""
elif ( grep "^PermitRootLogin.*" /etc/ssh/sshd_config ) # If it is present at the beginning of the line, but not set to yes, we assume it is restricted
then
	sed -i "s/^PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
    service ssh restart
	echo ""
	echo "SSH enabled for root"
	echo ""
else # Something went wrong
	echo ""
	echo "There was a problem when attempting to enable SSH access for the root user"
	echo ""
fi
