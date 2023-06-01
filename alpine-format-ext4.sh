#!/bin/bash
# Script to partition, format, and mount a disk as ext4

# Set the device name of the disk to partition and format
DEVICE="/dev/sdb"   # Replace with your desired device name

# Set the partition number to create
PARTITION="${DEVICE}1"

# Create a new partition
echo -e "o\nn\np\n1\n\n\nw" | fdisk "${DEVICE}"

# Format the partition as ext4
mkfs.ext4 "${PARTITION}"

# Create a mount point directory
MOUNT_POINT="/mnt/mydisk"   # Replace with your desired mount point
mkdir -p "${MOUNT_POINT}"

# Add an entry to /etc/fstab for permanent mounting
echo -e "${PARTITION}\t${MOUNT_POINT}\text4\tdefaults\t0 0" >> /etc/fstab

# Mount the partition
mount -a

echo "Disk partitioned, formatted as ext4, and permanently mounted at ${MOUNT_POINT}."