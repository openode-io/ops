
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

echo "Node.js"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
source /root/.bashrc
nvm install 12
npm i -g yarn

npm i -g pm2
pm2 list

###########################################################
# Internal services

### Redis
echo "installing redis"
apt install -y redis-server

### Mysql
echo "installing mysql server"
apt install -y mysql-server

echo "----------------- EXECUTE IN MYSQL"
echo "USE mysql; UPDATE user SET plugin='mysql_native_password' WHERE User='root'; FLUSH PRIVILEGES; "
mysql -u root

systemctl restart mysql.service
mysql_secure_installation

echo "Import the database, make sure to have /var/www/openode.sql"
read -p "Press enter to continue"
mysql -u root -p  < /var/www/openode.sql

### NGINX
apt install -y nginx
cp configs/nginx.conf /etc/nginx/nginx.conf

echo "** Copy core certs openode.io.crt privatekey.key"
read -p "Press enter to continue"

### rvm, ruby
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.7.0
echo '' >> ~/.bashrc
echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc

###########################################################
# openode-www
# 
cd /var/www
git clone https://github.com/openode-io/openode-www.git
cd /var/www/openode-www
bundle install
cp .test.env .production.env
vi .production.env
yarn
RAILS_ENV=production rails assets:precompile

echo "** Copy openode-www .production.env, config/master.key, config/credentials.yml.enc"
read -p "Press enter to continue"

echo "verify openode-www setup properly:"
echo "puts 'ok'" | RAILS_ENV=production rails c

# pm2
cd scripts
pm2 start node-start.json
pm2 save
pm2 startup # ensure start on boot

###########################################################
# openode-api
# 
cd /var/www
git clone https://github.com/openode-io/openode-api.git
cd /var/www/openode-api
apt install -y libmysqlclient-dev
bundle install

echo "** Copy openode-api .production.env, config/*"
read -p "Press enter to continue"

echo "verify openode-api setup properly:"
echo "puts 'ok'" | RAILS_ENV=production rails c

# pm2
cd scripts
pm2 start node-start.json
pm2 save
pm2 startup # ensure start on boot