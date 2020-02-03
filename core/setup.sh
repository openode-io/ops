
###########################################################
### GENERAL
set -e

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

echo "installing ntp"
sudo apt install -y ntp
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd.service
sudo timedatectl

echo "installing fail2ban"
sudo apt install -y fail2ban

sudo cp configs/jail.conf /etc/fail2ban/jail.conf
sudo /etc/init.d/fail2ban restart
sudo /etc/init.d/fail2ban status

echo "installing ufw"
sudo apt install -y ufw

sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw allow ntp

echo "activating ufw"
yes | sudo ufw enable

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
sudo apt install -y redis-server

### Mysql
echo "installing mysql server"
sudo apt install -y mysql-server

echo "----------------- EXECUTE IN MYSQL"
echo "USE mysql; UPDATE user SET plugin='mysql_native_password' WHERE User='root'; FLUSH PRIVILEGES; "
sudo mysql -u root

sudo systemctl restart mysql.service
sudo mysql_secure_installation

echo "Import the database, make sure to have /var/www/openode.sql"
read -p "Press enter to continue"
sudo mysql -u root -p  < /var/www/openode.sql

### NGINX
apt install -y nginx
sudo cp configs/nginx.conf /etc/nginx/nginx.conf

echo "** Copy core certs openode.io.crt privatekey.key"
read -p "Press enter to continue"

### rvm, ruby
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source /home/ubuntu/.rvm/scripts/rvm
rvm install 2.7.0
echo '' >> ~/.bashrc
echo 'source /home/ubuntu/.rvm/scripts/rvm' >> ~/.bashrc

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

echo "Migrating the data"
RAILS_ENV=production rails db:migrate

# pm2
cd scripts
pm2 start node-start.json
pm2 save
pm2 startup # ensure start on boot

#############################################################
# Datadog
echo "Go to https://app.datadoghq.com/account/settings#agent/ubuntu"
echo "IMPORTANT: enabled logs (logs_enabled) in /etc/datadog-agent/datadog.yaml"
read -p "Press enter to continue when installed"
sudo mkdir -p /etc/datadog-agent/conf.d/ruby.d
sudo cp configs/datadog_ruby_logs.yaml /etc/datadog-agent/conf.d/ruby.d/conf.yaml
sudo chown -R dd-agent:dd-agent /etc/datadog-agent/conf.d/ruby.d
sudo systemctl start datadog-agent
sudo service datadog-agent status

sudo mkdir -p /etc/datadog-agent/conf.d/ruby.d