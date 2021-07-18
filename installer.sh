# *** For Ubuntu 18.04 => Ubuntu 21.04 ***
GN='\033[0;32m'
RD='\033[0;31m'
YO='\033[0;33m'
NC='\033[0m'
if [ "$(whoami)" != 'root' ]; then
printf "${RD}You have to execute this script as root user${NC}\n"
exit 1;
fi
printf "${RD}Powered By DraGoN => ${YO}bit.ly/ydrag0n ${NC}\n"
sleep 5
printf "${GN}Installing Development/Production Environment${NC}\n"
sleep 5
printf "${RD}Please run this script on fresh install${NC}\n"
sleep 5
# Install Important Dependencies
printf "${GN}Installing Important Dependencies${NC}\n"
sleep 5
apt -y install unzip zip wget git curl software-properties-common apt-transport-https ca-certificates gnupg tar
sleep 5

# Add additional repositories for PHP, Redis, and MariaDB
printf "${GN}Adding additional repositories for PHP, Redis, and MariaDB${NC}\n"
sleep 5
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:chris-lea/redis-server
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sleep 5

# Update repositories list
printf "${GN}Updating repositories list${NC}\n"
sleep 5
apt update -y

# Add universe repository if you are on Ubuntu 18.04
printf "${GN}Adding universe repository if you are on Ubuntu 18.04${NC}\n"
sleep 5
apt-add-repository universe
sleep 5

# Install Dependencies
printf "${GN}Installing Apache, PHP, MariaDB, Redis${NC}\n"
sleep 5
apt -y install php7.4 php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.4 mariadb-server apache2 redis-server
sleep 5

# Enable Services
printf "${GN}Enable Services${NC}\n"
sleep 5
systemctl enable php7.4-fpm
systemctl enable apache2
systemctl enable mariadb
systemctl enable mysql
systemctl enable mysqld
systemctl enable redis-server
sleep 5

# Start Services
printf "${GN}Starting Services${NC}\n"
sleep 5
systemctl start php7.4-fpm
systemctl start apache2
systemctl start mariadb
systemctl start mysql
systemctl start mysqld
systemctl start redis-server
sleep 5

# Configuring Apache2
printf "${GN}Configuring Apache2${NC}\n"
sleep 5
a2enmod rewrite
systemctl restart apache2
a2dissite 000-default.conf
cd /etc/apache2/sites-available && rm -rf * && rm -rf /var/www/html/*
while true; do
    read -p "Do you want to install it for laravel ( Y => For Yes -- N => For No )?" yn
    case $yn in
        [Yy]* ) cd /etc/apache2/sites-available && wget https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-laravel.conf && a2ensite dragon-laravel.conf && systemctl reload apache2; break;;
        [Nn]* ) cd /etc/apache2/sites-available && wget https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-normal.conf && a2ensite dragon-normal.conf && systemctl reload apache2; break;;
        * ) echo "Please answer Y or N.";;
    esac
done
sleep 5
systemctl restart apache2

# Install Composer
printf "${GN}Installing Composer${NC}\n"
sleep 5
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/bin --filename=composer
sleep 5

# Install Nodejs
printf "${GN}Installing Nodejs${NC}\n"
sleep 5
curl -o- https://deb.nodesource.com/setup_14.x | bash
apt -y install nodejs gcc g++ make
sleep 5

# Install Yarn
printf "${GN}Installing Yarn${NC}\n"
sleep 5
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
     echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update -y && apt -y install yarn
sleep 5

# Install Python3
printf "${GN}Installing Python${NC}\n"
sleep 5
apt -y install python3 python3-pip
sleep 5
###
printf "${GN}Installation has been completed!${NC}\n"
sleep 5
printf "${GN}Please Run => mysql_secure_installation <= To Configure MariaDB${NC}\n"
sleep 5
printf "${GN}Please upload your files to /var/www/html if you have choosed Normal or Laravel${NC}\n"
sleep 5
printf "${YO}Enjoy!${NC}\n"
