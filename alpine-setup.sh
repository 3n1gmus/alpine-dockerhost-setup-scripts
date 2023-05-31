#!/bin/sh

Archive_File () {
        if [ -f $1 ]
        then
                Archive_Path="/etc/orig_config"
                EpocTime=`date +"%s"`
                [ ! -d $Archive_Path ] && mkdir -p $Archive_Path
                Source=$1
                IFS="/" read -a Path <<< $Source
                Destination="$Archive_Path/${Path[-1]}.original"
                if [ -f $Destination ]
                then
                        Destination="$Archive_Path/${Path[-1]}.${EpocTime}"
                fi
                echo "Moving $Source to $Destination"
                sudo mv $Source $Destination
        else
                echo "$1 does not exist."
        fi
}

# Update Repos
config_file="/etc/apk/repositories"
Archive_File $config_file
sudo echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" >> $config_file
sudo echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> $config_file

# Install Default apps
apk update
apk add sudo udev qemu-guest-agent mandoc man-pages docker docker-compose crond iptables

# setup udev
rc-update add udev sysinit
rc-update add udev-trigger
rc-update add udev-settle
rc-update add udev-postmount
rc-update add qemu-guest-agent
rc-update add docker
rc-update add crond
rc-update add iptables

# Service Starts
rc-service crond start
rc-service docker start
rc-service iptables start

# add wheel to sudoers
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# Create auto update job/script
echo -e "#!/bin/sh\napk upgrade --update | sed \"s/^/[\`date\`] /\" >> /var/log/apk-autoupgrade.log" > /etc/periodic/daily/apk-autoupgrade
chmod 700 /etc/periodic/daily/apk-autoupgrade