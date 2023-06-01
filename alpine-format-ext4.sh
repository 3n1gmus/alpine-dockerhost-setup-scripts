#!/bin/bash
# Script to partition, format, and mount a disk as ext4

# Define the disk device name (e.g., /dev/sdb)
DISK_DEVICE="/dev/sdb"

# Define the partition number (e.g., 1)
PARTITION_NUMBER="1"

# Define the mount point directory (e.g., /mnt/data)
MOUNT_POINT="/mnt/data"

# Partition the disk
sudo parted $DISK_DEVICE mklabel gpt
sudo parted -a optimal $DISK_DEVICE mkpart primary ext4 0% 100%

# Format the partition as ext4
sudo mkfs.ext4 ${DISK_DEVICE}${PARTITION_NUMBER}

# Create the mount point directory if it doesn't exist
sudo mkdir -p $MOUNT_POINT

# Get the UUID of the partition
UUID=$(sudo blkid -s UUID -o value ${DISK_DEVICE}${PARTITION_NUMBER})

# Add a permanent mount entry to /etc/fstab
echo "UUID=$UUID  $MOUNT_POINT  ext4  defaults  0  2" | sudo tee -a /etc/fstab

# Mount the partition
sudo mount -a

echo "Disk partitioned, formatted as ext4, and mounted successfully."