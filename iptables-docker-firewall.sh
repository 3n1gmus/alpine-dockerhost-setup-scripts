#!/bin/bash
# Automatic configuration of firewall for Docker container ports

# Enable the firewall
rc-service iptables start

# Retrieve Docker container ports
DOCKER_PORTS=$(docker ps --format "{{.Ports}}" | awk -F "->" '{print $2}' | cut -d '/' -f 1)

# Create an array to store the ports to be opened
declare -a OPEN_PORTS

# Allow Docker container ports
for port in $DOCKER_PORTS
do
    iptables -I INPUT -p tcp --dport $port -j ACCEPT
    OPEN_PORTS+=("$port")
done

# Close unused ports except for port 22 (SSH)
ACTIVE_PORTS=$(iptables -nL INPUT --line-numbers | grep -v "ACCEPT" | awk -v portlist="${OPEN_PORTS[*]}" '$0 !~ portlist {print $1}')
for line in $ACTIVE_PORTS
do
    port=$(iptables -nL INPUT --line-numbers | awk -v line="$line" '$1 == line {print $NF}')
    if [ "$port" != "22" ]; then
        iptables -D INPUT "$line"
    fi
done

# Save the firewall rules
/etc/init.d/iptables save

# Restart the firewall to apply the new rules
rc-service iptables restart

echo "Docker container ports have been opened in the firewall"
