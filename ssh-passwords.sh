#!/bin/bash
# Script to disable password authentication in SSH config

# Backup the SSH configuration file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Replace the PasswordAuthentication line with the new configuration
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart the SSH service
service ssh restart

echo "Password authentication has been disabled in the SSH configuration."