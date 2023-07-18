#!/bin/sh

# Check if the script is executed with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Prompt the user for the new hostname
read -p "Enter the new hostname: " new_hostname

# Validate if the provided hostname is not empty
if [ -z "$new_hostname" ]; then
    echo "Error: Hostname cannot be empty."
    exit 1
fi

# Set the new hostname
echo "$new_hostname" > /etc/hostname

# Update the hostname in the current running system
hostname "$new_hostname"

# Update the hostname in the hosts file
sed -i "s/127.0.0.1.*/127.0.0.1\t$new_hostname localhost/" /etc/hosts

echo "Hostname changed to $new_hostname. The change will take effect after a reboot."
