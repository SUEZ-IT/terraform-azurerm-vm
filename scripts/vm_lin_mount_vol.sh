#!/bin/bash

## Create partition, format and mount aditionnal disk(s) 
disks=$(lsblk --fs --json | jq -r '.blockdevices[] | select(.children == null and .fstype == null) | .name'| grep -i "sd")
[[ -z "$disks" ]] && { echo "No disk to format." ; exit 0; }

for disk in $disks
do
    parted /dev/${disk} mklabel gpt --script
    parted /dev/${disk} mkpart primary ext4 0% 100% --script
    SECONDS=0
    until [ -b "/dev/${disk}1" ] || [ $SECONDS -eq 20 ]; do
        sleep $(( $SECONDS++ ))
    done
    mkfs.ext4 /dev/${disk}1
    mkdir /data${disk}
    UUID="$(blkid -s UUID -o value /dev/${disk}1)"
    echo "UUID="$UUID"  /data$disk ext4 defaults 0 1" | tee -a /etc/fstab
    mount -a
done