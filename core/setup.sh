
###########################################################
### GENERAL
set -e

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
apt install -y fail2ban

cp configs/jail.conf /etc/fail2ban/jail.conf
/etc/init.d/fail2ban restart
/etc/init.d/fail2ban status

echo "installing ufw"
apt install -y ufw

ufw allow 80
ufw allow 443
ufw allow 22
ufw allow ntp

echo "activating ufw"
yes | ufw enable

###########################################################
# Internal services

echo "installing redis"
apt install -y redis-server

echo "installing mysql server"
apt install -y mysql-server
mysql -h127.0.0.1 -uroot -e"USE mysql; UPDATE user SET plugin='mysql_native_password' WHERE User='root'; FLUSH PRIVILEGES; "
systemctl restart mysql.service
mysql_secure_installation