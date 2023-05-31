#!/bin/bash
# Script to configure SSH security settings

# Backup the SSH configuration file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Update the SSH configuration
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 1800/' /etc/ssh/sshd_config
sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/' /etc/ssh/sshd_config

# Restart the SSH service
service ssh restart

echo "SSH security settings have been updated."