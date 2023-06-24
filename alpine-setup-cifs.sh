apk add cifs-utils
rc-update add netmount
rc-service netmount start
rc-status
echo "If netmount services are not started the system may need a reboot."