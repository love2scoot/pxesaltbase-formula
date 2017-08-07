#!/bin/bash

# Get the new hostname
echo "Enter the new hostname followed by [ENTER]:"
read newhostname

# Confirm the hostname
while true; do
    read -p "Is $newhostname the new hostname you wish to use? (y/n)" confirm
    case $confirm in
        [Yy]* ) break;;
        [Nn]* ) echo "Aborting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Apply the hostname including updating the salt minion_id
echo $newhostname > /etc/hostname
echo $newhostname > /etc/salt/minion_id
sed -i "s|127.0.1.1.*|127.0.1.1        $newhostname salt|g" /etc/hosts

# ---Completing the steps for the changes to salt
# First, we need to delete the old key (all keys actually) because it is associated with the old name
salt-key -y -D
# Restarting the minion service will grab the new minion_id
service salt-minion restart
# displaying the list of all keys will force the master to see the new hostname under unaccepted keys
salt-key -L
# We auto-accept the new key and minion name
salt-key -y -A
# We output the list of keys to verify the key was properly accepted
salt-key -L
# We remind the user to reboot the machine to apply the change
echo ""
echo "*** Please reboot this machine to complete the hostname change"