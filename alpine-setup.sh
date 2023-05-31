#!/bin/sh

# Update Repos
mkdir -p "/etc/orig_config"
cp "/etc/apk/repositories" "/etc/orig_config/repositories"
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" >> "/etc/apk/repositories"
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> "/etc/apk/repositories"

# Install Default apps
apk update
apk add sudo 
apk add udev
apk add qemu-guest-agent
apk add mandoc
apk add man-pages
apk add docker
apk add docker-compose
apk add crond
apk add iptables
apk add vim

# setup udev
rc-update add udev sysinit
rc-update add udev-trigger
rc-update add udev-settle
rc-update add udev-postmount
rc-update add qemu-guest-agent
rc-update add docker
rc-update add crond
rc-update add iptables

# Open SSH port
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

# Service Starts
rc-service crond start
rc-service docker start
rc-service iptables start

# add wheel to sudoers
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# Create auto update job/script
echo -e "#!/bin/sh\napk upgrade --update | sed \"s/^/[\`date\`] /\" >> /var/log/apk-autoupgrade.log" > /etc/periodic/daily/apk-autoupgrade
chmod 700 /etc/periodic/daily/apk-autoupgrade