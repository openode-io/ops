#################
# Initial extended disk

echo "Copy /home/ubuntu"
sudo cp -R /home/ubuntu /root

echo "List available disks:"
lsblk

echo "Create partition, then enter: n, all defaults, then w"
sudo fdisk /dev/sdb

echo "Format the partition:"
sudo mkfs.ext4 /dev/sdb1

echo "Mount the partition:"
sudo mount /dev/sdb1 /home/

echo "Verify properly mounted:"
df -h

echo "Look for the proper uuid of the disk"
sudo blkid

echo "Add to /etc/fstab UUID=d25f5030-8c62-4f34-9489-35e9aad33028 /home ext4 nofail 0 0"

echo ""
sudo chown -R ubuntu:ubuntu /home
sudo chown -R ubuntu:ubuntu /root/ubuntu
echo "Then cp -R /root/ubuntu /home/"

#################
## resizing block storage
#sudo umount /home
#sudo fdisk /dev/sdc # Important! the disk

#sudo e2fsck -f /dev/sdc1
#sudo resize2fs /dev/sdc1
#sudo mount /dev/sdc1 /home/