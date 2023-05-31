#!/bin/sh
# Script to set up networking with a static IP address and configure DNS on Alpine Linux

# Set the network interface name
INTERFACE="eth0"   # Replace with your network interface name

# Set the static IP address, netmask, gateway, and DNS servers
IP_ADDRESS="192.168.1.100"    # Replace with your desired static IP address
NETMASK="255.255.255.0"       # Replace with your netmask
GATEWAY="192.168.1.1"         # Replace with your gateway IP address
DNS_SERVERS="8.8.8.8 8.8.4.4"  # Replace with your desired DNS server(s)

# Backup the existing network configuration file
cp /etc/network/interfaces /etc/network/interfaces.bak

# Configure the network interface
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $INTERFACE
iface $INTERFACE inet static
  address $IP_ADDRESS
  netmask $NETMASK
  gateway $GATEWAY
EOF

# Check if DNS servers are already present in resolv.conf
if ! grep -qxF "$DNS_SERVERS" /etc/resolv.conf; then
  # Backup the existing resolv.conf file
  cp /etc/resolv.conf /etc/resolv.conf.bak

  # Configure DNS
  for server in $DNS_SERVERS; do
    echo "nameserver $server" >> /etc/resolv.conf
  done
fi

# Restart the networking service
/etc/init.d/networking restart

echo "Networking has been configured with a static IP address and DNS settings."
