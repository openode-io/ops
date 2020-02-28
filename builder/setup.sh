
#################
# General
echo "Update ubuntu..."
sudo apt-get update

echo "Upgrading ubuntu..."
sudo apt-get upgrade -y

echo "apt autoremove..."
sudo apt autoremove -y

echo "Upgrading ubuntu again..."
sudo apt-get upgrade -y

echo "apt autoremove again..."
sudo apt autoremove -y

echo "installing fail2ban"
sudo apt install -y fail2ban

sudo cp configs/jail.conf /etc/fail2ban/jail.conf
sudo /etc/init.d/fail2ban restart
sudo /etc/init.d/fail2ban status

echo "installing ufw"
sudo apt install -y ufw

sudo ufw allow 22

echo "activating ufw"
yes | sudo ufw enable

#################
# Docker
sudo apt install -y docker.io

#################
# Files syncing
sudo apt install -y nodejs
sudo apt install -y unzip

sudo mkdir -p /root/openode-www/api/lib
sudo chown -R ubuntu:ubuntu /root

echo "Copy /root/openode-www/api/lib/lfiles.js"
cp configs/lfiles.js /root/openode-www/api/lib/

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