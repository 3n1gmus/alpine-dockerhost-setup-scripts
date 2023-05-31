#!/bin/sh
# Script to partition the whole drive, format it as ext4, and add it as a permanent mount at boot

# Specify the device and mount point
DEVICE="/dev/sdb"   # Replace with your device name (without partition number)
MOUNT_POINT="/mnt/new_volume"   # Replace with your desired mount point

# Partition the entire drive
echo -e "g\nn\n\n\n\nw" | fdisk $DEVICE

# Format the partition with ext4
PARTITION="${DEVICE}1"
mkfs.ext4 $PARTITION

# Create the mount point directory
mkdir -p $MOUNT_POINT

# Get the UUID of the formatted partition
UUID=$(blkid -s UUID -o value $PARTITION)

# Add an entry to /etc/fstab for permanent mounting
echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 0" >> /etc/fstab

# Mount the partition
mount $MOUNT_POINT

echo "New volume has been partitioned, formatted as ext4, and mounted at $MOUNT_POINT."
