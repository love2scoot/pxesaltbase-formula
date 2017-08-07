#!/bin/bash

#---CONSTANTS
outputfile="/etc/network/interfaces"

#---FUNCTIONS
basicoutput () # All interface files start with this
{
	echo "# This file describes the network interfaces available on your system"
	echo "# and how to activate them. For more information, see interfaces(5)."
	echo ""
	echo "# The loopback network interface"
	echo "auto lo"
	echo "iface lo inet loopback"
	echo ""
	echo "# The primary network interface"
}

dhcpoutput () # Output for DHCP configuration
{
	echo "# DHCP Configuration"
	echo "auto ${ethname}"
	echo "iface ${ethname} inet dhcp"
}

staticoutput () # Output for Static IP configuration
{
	echo "# Static IP in WDC"
	echo "auto ${1}"
	echo "iface ${1} inet static"
	echo "	address ${2}"
	echo "	netmask ${3}"
#	echo "	network "
#	echo "	broadcast "
	echo "	gateway ${4}"
	echo "	dns-search ${5}"
	echo "	dns-nameservers ${6} ${7}"
}

isipvalid () # Check to see if the IP is valid
{
    separator="\." # Make sure to escape the .
    dotcount=$(grep -o "$separator" <<< "$1" | grep -c .) # Check for extra octets
    valid=`grep -oP '\b(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])[.](?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])[.](?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])[.](?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]))\b' <<< "$1"`
    if [ "$dotcount" -eq 3 ] && [ "$valid" ]
    then
        return 0 # We have a valid IP address
    else
        return 1 # Not a valid IP
    fi
}

#---START

# Intro
echo "This wizard will help you change the network configuration on your machine"

# Figure out the name of the Ethernet adapter
if ( grep eth0 $outputfile )
then
	ethname="eth0" #Found eth0
else
	ethname=`ifconfig | grep -w -m 1 en.... | awk '{print $1;}'` #Derived Ethernet interface name
fi

# Configure as Static or DHCP?
echo ""
echo "---STEP 1: STATIC vs DHCP" 
while true; do
    echo ""
    echo "How would you like to configure adapter ${ethname}?"
	read -r -p "(S)tatic IP / (D)HCP [S/D] " answer
	case "${answer}" in
		(s* | S*)
			break
			;;
		(d* | D*)
			basicoutput > $outputfile
			dhcpoutput >> $outputfile
			ifdown ${ethname}
			ifup ${ethname}
			echo ""
			echo "---IP configuration change complete"
			exit 0
			;;
		(*)
			echo "Unknown option: ${answer}"
			;;
	esac
done

# OK, configure as static
echo ""
echo "---STEP 2: IP ADDRESS" 
while true; do
    echo ""
    read -r -p "Please supply the desired IP address (no leading zeros): " myip
    echo "Checking IP..."
    isipvalid $myip
    if [ $? -eq 0 ]
    then
        echo "That looks like a valid IP"
        break
    else
        echo "$myip is not a valid IP address" # Something is wrong with the octets
    fi
done

# We need a subnet now
echo ""
echo "---STEP 3: SUBNET MASK" 
while true; do
    echo ""
    echo "-------------------------------------"
    echo "| Bits | Mask            | Hosts    |"
    echo "-------------------------------------"
    echo "| /8   | 255.0.0.0       | 16777214 |"
    echo "| /9   | 255.128.0.0     | 8388606  |"
    echo "| /10  | 255.192.0.0     | 4194302  |"
    echo "| /11  | 255.224.0.0     | 2097150  |"
    echo "| /12  | 255.240.0.0     | 1048574  |"
    echo "| /13  | 255.248.0.0     | 524286   |"
    echo "| /14  | 255.252.0.0     | 262142   |"
    echo "| /15  | 255.254.0.0     | 131070   |"
    echo "| /16  | 255.255.0.0     | 65534    |"
    echo "| /17  | 255.255.128.0   | 32766    |"
    echo "| /18  | 255.255.192.0   | 16382    |"
    echo "| /19  | 255.255.224.0   | 8190     |"
    echo "| /20  | 255.255.240.0   | 4094     |"
    echo "| /21  | 255.255.248.0   | 2046     |"
    echo "| /22  | 255.255.252.0   | 1022     |"
    echo "| /23  | 255.255.254.0   | 510      |"
    echo "| /24  | 255.255.255.0   | 254      |"
    echo "| /25  | 255.255.255.128 | 126      |"
    echo "| /26  | 255.255.255.192 | 62       |"
    echo "| /27  | 255.255.255.224 | 30       |"
    echo "| /28  | 255.255.255.240 | 14       |"
    echo "| /29  | 255.255.255.248 | 6        |"
    echo "| /30  | 255.255.255.252 | 2        |"
    echo "-------------------------------------"
    echo ""
	read -r -p "Please supply the bits of the desired subnet (see table above): " mysub
    case "${mysub}" in
		(/8 | 8) mymask="255.0.0.0"; break;;
		(/9 | 9) mymask="255.128.0.0"; break;;
		(/10 | 10) mymask="255.192.0.0"; break;;
		(/11 | 11) mymask="255.224.0.0"; break;;
		(/12 | 12) mymask="255.240.0.0"; break;;
		(/13 | 13) mymask="255.248.0.0"; break;;
		(/14 | 14) mymask="255.252.0.0"; break;;
		(/15 | 15) mymask="255.254.0.0"; break;;
		(/16 | 16) mymask="255.255.0.0"; break;;
		(/17 | 17) mymask="255.255.128.0"; break;;
		(/18 | 18) mymask="255.255.192.0"; break;;
		(/19 | 19) mymask="255.255.224.0"; break;;
		(/20 | 20) mymask="255.255.240.0"; break;;
		(/21 | 21) mymask="255.255.248.0"; break;;
		(/22 | 22) mymask="255.255.252.0"; break;;
		(/23 | 23) mymask="255.255.254.0"; break;;
		(/24 | 24) mymask="255.255.255.0"; break;;
		(/25 | 25) mymask="255.255.255.128"; break;;
		(/26 | 26) mymask="255.255.255.192"; break;;
		(/27 | 27) mymask="255.255.255.224"; break;;
		(/28 | 28) mymask="255.255.255.240"; break;;
		(/29 | 29) mymask="255.255.255.248"; break;;
		(/30 | 30) mymask="255.255.255.252"; break;;
		(*) echo "Unknown option: ${mysub}";;
	esac
done

# Get the gateway
echo ""
echo "---STEP 4: GATEWAY" 
while true; do
    echo ""
    read -r -p "Now we'll need the IP Address of the gateway (no leading zeros): " mygate
    echo "Checking IP..."
    isipvalid $mygate
    if [ $? -eq 0 ]
    then
        echo "That looks like a valid IP"
        break
    else
        echo "$mygate is not a valid IP address" # Something is wrong with the octets
    fi
done

# Get the dnsdomain
echo ""
echo "---STEP 5: DNS Domain(s)" 
echo "(Optional, but suggested)"
echo 'Example: "bobbarker.com"'
echo ""
read -r -p "Please provide a dns search domain: " dnsdomain
if [ -z "$dnsdomain" ]
then
    dnsdomain="#" # Passing a hash to retain the numbering of passed vales to the static IP function
fi

#Get the DNS Server IP
echo ""
echo "---STEP 6a: DNS NAMESERVER" 
while true; do
    echo ""
    read -r -p "We'll need the IP Address of the local DNS Server (no leading zeros): " dnsnameserver1
    echo "Checking IP..."
    isipvalid $dnsnameserver1
    if [ $? -eq 0 ]
    then
        echo "That looks like a valid IP"
        break
    else
        echo "$dnsnameserver1 is not a valid IP address" # Something is wrong with the octets
    fi
done

#Get the DNS Server IP
echo ""
echo "---STEP 6b: DNS NAMESERVER (Secondary)" 
while true; do
    echo ""
    read -r -p "Secondary DNS Server IP / Enter to skip (no leading zeros): " dnsnameserver2
    if [ -z "$dnsnameserver2" ]
    then
        dnsnameserver2="#" # Passing a hash to retain the numbering of passed vales to the static IP function
        break
    fi
    echo "Checking IP..."
    isipvalid $dnsnameserver2
    if [ $? -eq 0 ]
    then
        echo "That looks like a valid IP"
        break
    else
        echo "$dnsnameserver2 is not a valid IP address" # Something is wrong with the octets
    fi
done

# Confirm the config
while true; do
    echo ""
    echo "---Validate the Configuration----"
    basicoutput
    staticoutput ${ethname} ${myip} ${mymask} ${mygate} ${dnsdomain} ${dnsnameserver1} ${dnsnameserver2}
    echo "---------------------------------"
    echo ""
    read -r -p "Would you like to apply this configuration? (Y/N): " pleaseconfirm
	case "${pleaseconfirm}" in
		(y* | Y*)
            # Output Static IP settings to file
            basicoutput > $outputfile
            staticoutput ${ethname} ${myip} ${mymask} ${mygate} ${dnsdomain} ${dnsnameserver1} ${dnsnameserver2} >> $outputfile
            ifdown ${ethname}
            ifup ${ethname}
            ifconfig ${ethname}
            echo ""
            echo "*********"
            echo "Check the adapter information above.  If the IP has *not* changed, you will need to reboot in order to apply the change to a static IP"
            break
			;;
		(n* | N*)
            echo ""
            echo "---Aborting configuration"
			exit 1
			;;
		(*)
			echo "Unknown option: ${answer}"
			;;
	esac
done

echo ""
echo "---IP configuration change complete"