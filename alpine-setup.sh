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
apk add sudo udev qemu-guest-agent mandoc man-pages

# setup udev
rc-update add udev sysinit
rc-update add udev-trigger
rc-update add udev-settle
rc-update add udev-postmount
rc-update add qemu-guest-agent

# add wheel to sudoers
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# Install and start Cron
apk add crond && rc-service crond start && rc-update add crond

# Create auto update job/script
echo -e "#!/bin/sh\napk upgrade --update | sed \"s/^/[\`date\`] /\" >> /var/log/apk-autoupgrade.log" > /etc/periodic/daily/apk-autoupgrade
chmod 700 /etc/periodic/daily/apk-autoupgrade

# AppArmor
apk add apparmor apparmor-utils apparmor-profiles

# AppArmor start-up
config_file="/boot/extlinux.conf"
Archive_File $config_file
$config="/etc/orig_config/extlinux.conf.original"
while IFS= read -r line; do
	if [ $line == *"APPEND"* ]
	then
		$line = $line" lsm=landlock,yama,apparmor"
		sudo echo "$line" >> $config_file
	else
		sudo echo "$line" >> $config_file
	fi
done <$config

rc-service apparmor start
rc-update add apparmor boot
