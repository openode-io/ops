
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
sudo ufw allow 80
sudo ufw allow 443

echo "activating ufw"
yes | sudo ufw enable

echo "installing zip"
sudo apt install -y zip

echo "installing NGINX"
sudo apt install -y nginx
sudo cp configs/nginx.conf /etc/nginx/nginx.conf

#################
# Docker
sudo apt install -y docker.io
sudo cp configs/docker-daemon.json /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker

#################
# Files syncing
sudo apt install -y nodejs
sudo apt install -y unzip

sudo mkdir -p /root/openode-www/api/lib
sudo chown -R ubuntu:ubuntu /root

echo "Copy /root/openode-www/api/lib/lfiles.js"
cp configs/lfiles.js /root/openode-www/api/lib/

### kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

sudo mkdir /home/tmp
sudo chmod -R 777 /home/tmp
sudo chown -R ubuntu:ubuntu /home

# install openode cli
sudo apt install npm
npm i -g openode

echo "!!!"
echo "ensure builder_kubeconfig_path (in .production.openode.yml) to the proper locations"

