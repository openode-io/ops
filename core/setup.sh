
echo "Update ubuntu..."
apt-get update

echo "Upgrading ubuntu..."
apt-get upgrade -y

echo "apt autoremove..."
apt autoremove -y

echo "Upgrading ubuntu again..."
apt-get upgrade -y

echo "apt autoremove again..."
apt autoremove -y

echo "installing ntp"
apt install -y ntp
timedatectl set-ntp true
systemctl restart systemd-timesyncd.service
timedatectl

echo "installing fail2ban"
apt install -y fail2ban # TODO add configurations