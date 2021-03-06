#!/bin/bash
GN='\033[0;32m'
RD='\033[0;31m'
YO='\033[0;33m'
NC='\033[0m'

clear

if [ "$(whoami)" != 'root' ]; then
printf "${RD}You have to execute this script as root user!${NC}\n"
exit 1;
fi
function GetSysInfo() {
    SYS_VERSION=$(cat /etc/issue)
	SYS_BIT=$(getconf LONG_BIT)
	MEM_TOTAL=$(free -m|grep Mem|awk '{print $2}')
	CPU_INFO=$(getconf _NPROCESSORS_ONLN)

	printf "${GN}Your OS${NC}:${YO} ${SYS_VERSION}${NC}\n"
	printf "${YO}Your System Specs${NC}: ${NC}Bit${NC}: ${GN}x${SYS_BIT}${NC} -- ${NC}Ram: ${GN}${MEM_TOTAL}Mb ${NC} -- Cores: ${GN}${CPU_INFO}${NC}\n"
}
function install_or_no() {
startTime=`date +%s`
GetSysInfo
echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Do you wish to start the installation? **      |
|                                                      |
|    1.) Yes                                           |
|    2.) No                                            |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo "Great 🙂"

elif [ "$choice" == "2" ]; then

    echo "Okay 🙃"
    exit

else

    printf "${RD}Invalid choice!${NC}😕\n" && sleep 3
    clear && install_or_no

fi
}
install_or_no

function ols() {
    printf "#${YO}##################################################################${NC}#\n"
    printf "#${YO}                                                                  ${NC}#\n"
    printf "#${YO}This For Openlitespeed Users ( Don't worry if you got any error ).${NC}#\n"
SERVICE="lsws"
ADMIN_PASSWORD=$(cat /usr/local/lsws/adminpasswd)
if systemctl status "$SERVICE" >/dev/null
then
    printf "#${RD}                      *** Please Save This ***                    ${NC}#\n"
    printf "#${GN}       Openlitespeed: ${ADMIN_PASSWORD}${NC}    #\n"
    printf "#${YO}                                                                  ${NC}#\n"
	printf "#${YO}##################################################################${NC}#\n"
      
else
    echo ""
fi
}

clear
# Install Important Dependencies
printf "${GN}#### Installing Important Dependencies ####${NC}\n"
sleep 5
apt -y install unzip zip wget git curl software-properties-common apt-transport-https ca-certificates gnupg tar gcc g++ make cmake
sleep 5

clear
# Add additional repositories for PHP, Redis, and MariaDB
printf "${GN}#### Adding additional repositories for PHP,Openlitespeed, Redis, Nodejs, Yarn, and MariaDB ####${NC}\n"
sleep 5
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:chris-lea/redis-server
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash
curl -o- https://deb.nodesource.com/setup_14.x | bash
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update -y
sleep 5

clear
# Update repositories list
printf "${GN}#### Updating repositories list ####${NC}\n"
sleep 5
apt update -y

clear
# Add universe repository if you are on Ubuntu 18.04
printf "${GN}#### Adding universe repository if you are on Ubuntu 18.04 ####${NC}\n"
sleep 5
apt-add-repository universe
##
clear

function webserver_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|        ** Please Select Your Favourite WebServer **        |
|                                                            |
|    1.) Apache                                              |
|    2.) Nginx                                               |
|    3.) Openlitespeed  (You will configure it by yourself.) |
|                                                            |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing Apache ..."
    apt -y install apache2
    a2enmod rewrite
    a2dissite 000-default.conf
    rm -rf /var/www/html/* && rm -rf /etc/apache2/sites-available/*
    sleep 3
##
function apache_vhost() {
echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                    ** Please Select **                       |
|              1.) For  Laravel.                               |
|              2.) For Any PHP Script.                         |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    curl -o /etc/apache2/sites-available/dragon-laravel.conf https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-laravel.conf && a2ensite dragon-laravel.conf && systemctl reload apache2

elif [ "$choice" == "2" ]; then

    curl -o /etc/apache2/sites-available/dragon-normal.conf https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-normal.conf && a2ensite dragon-normal.conf && systemctl reload apache2

else

    echo "Please select 1 or 2." && sleep 3
    clear && apache_vhost

fi
}

apache_vhost

systemctl enable apache2
systemctl start apache2
systemctl restart apache2

elif [ "$choice" == "2" ]; then

    echo -e "Installing Nginx ..."
apt -y install nginx
rm -rf /var/www/html/*
sleep 3
# remove default config
rm -rf /etc/nginx/sites-enabled/default
###
function nginx_vhost() {    
echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                    ** Please Select **                       |
|              1.) For  Laravel.                               |
|              2.) For Any PHP Script.                         |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    curl -o /etc/nginx/sites-available/dragon-laravel.conf https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-nginx-laravel.conf 

elif [ "$choice" == "2" ]; then

    curl -o /etc/nginx/sites-available/dragon-normal.conf  https://raw.githubusercontent.com/mrnitr0/Development-Environment/main/dragon-nginx-normal.conf

else

    echo "Please select 1 or 2." && sleep 3
    clear && nginx_vhost

fi
}

nginx_vhost

    systemctl enable nginx
#   systemctl start nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing Openlitespeed ..."
    apt -y install openlitespeed
    systemctl enable lsws
    systemctl start lsws

else

    echo -e "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && webserver_selection

fi
}

webserver_selection
##
clear

function php_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Please Select Your Favourite PHP Version **    |
|                                                      |
|    1.) 5.6                                           |
|    2.) 7.0                                           |
|    3.) 7.1                                           |
|    4.) 7.2                                           |
|    5.) 7.3                                           |
|    6.) 7.4                                           |
|    7.) 8.0                                           |
|                                                      |
|                8.) Don't Install                     |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then
    
    echo -e "Installing PHP 5.6 ..."
    sleep 5
##
clear
function phphost1_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 5.6  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php5.6 php5.6-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php5.6
    systemctl restart apache2


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php5.6 php5.6-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET1="/run/php/php5.6-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET1}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET1}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
    echo -e "Not Available Right Now!" && sleep 3
    clear && php_selection

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost1_selection

fi
}

phphost1_selection
####

elif [ "$choice" == "2" ]; then
 
    echo -e "Installing PHP 7.0 ..."
    sleep 5
clear
###
function phphost2_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 7.0  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php7.0 php7.0-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.0
    systemctl restart apache2


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php7.0 php7.0-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET2="/run/php/php7.0-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET2}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET2}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
	apt -y install lsphp70 lsphp70-{mysql,sqlite3,pgsql,curl,imap}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost2_selection

fi
}

phphost2_selection
####

elif [ "$choice" == "3" ]; then

    echo -e "Installing PHP 7.1 ..."
    sleep 5
clear
###
function phphost3_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 7.1  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php7.1 php7.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.1
    systemctl restart apache2

elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php7.1 php7.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET3="/run/php/php7.1-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET3}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET3}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
	apt -y install lsphp71 lsphp71-{mysql,sqlite3,pgsql,curl,imap}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost3_selection

fi
}

phphost3_selection
####

elif [ "$choice" == "4" ]; then

    echo -e "Installing PHP 7.2 ..."
    sleep 5
####
clear

function phphost4_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 7.2  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php7.2 php7.2-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.2
    systemctl restart apache2


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php7.2 php7.2-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET4="/run/php/php7.2-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET4}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET4}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
    apt -y install lsphp72 lsphp72-{mysql,tidy,sqlite3,pgsql,curl,intl,imap,snmp}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost4_selection

fi
}

phphost4_selection
####

elif [ "$choice" == "5" ]; then

    echo -e "Installing PHP 7.3 ..."
    sleep 5
####
clear

function phphost5_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 7.3  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php7.3 php7.3-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.3
    systemctl restart apache2


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php7.3 php7.3-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET5="/run/php/php7.3-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET5}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET5}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
    apt -y install lsphp73 lsphp73-{mysql,tidy,sqlite3,pgsql,curl,intl,imap,snmp}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost5_selection

fi
}

phphost5_selection
####

elif [ "$choice" == "6" ]; then

    echo -e "Installing PHP 7.4 ..."
    sleep 5
####
clear

function phphost6_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 7.4  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    sleep 3
    apt -y install php7.4 php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php7.4
    systemctl restart apache2


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php7.4 php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET6="/run/php/php7.4-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET6}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET6}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
	apt -y install lsphp74 lsphp74-{mysql,tidy,sqlite3,pgsql,curl,intl,imap,snmp}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost6_selection

fi
}

phphost6_selection
####

elif [ "$choice" == "7" ]; then

    echo -e "Installing PHP 8.0 ..."
    sleep 5
####
clear

function phphost7_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                                |
|       ##  PHP 8.0  ##          |
|                                |
|    ** Please Select **         |
|                                |
|    1.) For Apache              |
|    2.) For Nginx               |
|    3.) For Openlitespeed       |
|                                |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing For Apache ..."
    apt -y install php8.0 php8.0-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache} libapache2-mod-php8.0
    systemctl restart apache2
    sleep 3


elif [ "$choice" == "2" ]; then

    echo -e "Installing For Nginx ..."
    sleep 3
    apt -y install php8.0 php8.0-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip,intl,imap,opcache}
    PHP_SOCKET7="/run/php/php8.0-fpm.sock"
    sed -i -e "s@<php_socket>@${PHP_SOCKET7}@g" /etc/nginx/sites-available/dragon-laravel.conf
    sed -i -e "s@<php_socket>@${PHP_SOCKET7}@g" /etc/nginx/sites-available/dragon-normal.conf
    ln -sf /etc/nginx/sites-available/dragon-laravel.conf /etc/nginx/sites-enabled/dragon-laravel.conf
    ln -sf /etc/nginx/sites-available/dragon-normal.conf /etc/nginx/sites-enabled/dragon-normal.conf
    systemctl start nginx
    systemctl restart nginx

elif [ "$choice" == "3" ]; then

    echo -e "Installing For Openlitespeed ..."
    sleep 3
    apt -y install lsphp80 lsphp80-{mysql,tidy,sqlite3,pgsql,curl,intl,imap,snmp}
    systemctl restart lsws

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && phphost7_selection

fi
}

phphost7_selection
####

elif [ "$choice" == "8" ]; then

    echo -e "Okay! 🙂"
    sleep 3

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && php_selection

fi
}

php_selection
####
clear

function sql_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Please Select Your Favourite SQL Server  **    |
|                                                      |
|    1.) MariaDB   (Latest)                            |
|    2.) Don't Install                                 |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    apt -y install mariadb-server
    systemctl enable mariadb mysqld mysql
    systemctl start mariadb mysqld mysql

elif [ "$choice" == "2" ]; then

    echo -e "Okay 🙂!"
    sleep 3

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && sql_selection

fi
}

sql_selection
####
clear

function redis_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Do you want to install Redis? **               |
|                                                      |
|    1.) Yes                                           |
|    2.) No                                            |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then
    echo -e "Installing Redis ..."
    sleep 5
    apt -y install redis-server
    systemctl enable redis-server
    systemctl start redis-server

elif [ "$choice" == "2" ]; then

    echo -e "Okay!"
    sleep 5

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && redis_selection

fi
}

redis_selection
##
clear

function nodejs_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Do you want to install Nodejs? **              |
|                                                      |
|    1.) Yes                                           |
|    2.) No                                            |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing Nodejs ..."
    sleep 5
    apt -y install nodejs

elif [ "$choice" == "2" ]; then

    echo -e "Okay!"
    sleep 5

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && nodejs_selection

fi
}

nodejs_selection
##
clear

function yarn_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|    ** Do you want to install Yarn? **                |
|                                                      |
|    1.) Yes                                           |
|    2.) No                                            |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing Yarn ..."
    sleep 5
    apt -y install yarn

elif [ "$choice" == "2" ]; then

    echo -e "Okay!"
    sleep 2

else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && yarn_selection

fi
}

yarn_selection
##
clear

function python_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|           ** PLease Select Python Version **         |
|                                                      |
|              1.) Python 2.7                          |
|              2.) Python 3                            |
|              3.) Don't Install                       |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing Python 2.7 ..."
    sleep 5
    apt -y install python

elif [ "$choice" == "2" ]; then

    echo -e "Installing Python 3 ..."
    sleep 5
    apt -y install python python3-pip

elif [ "$choice" == "3" ]; then

    echo -e "Okay!"
    sleep 5


else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && python_selection

fi
}

python_selection
##
clear

function composer_selection() {    

echo -e "${YO}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|         ** Do you want to install composer? **       |
|                                                      |
|              1.) Yes                                 |
|              2.) No                                  |
|                                                      |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"

read -e -p "Select : " choice

if [ "$choice" == "1" ]; then

    echo -e "Installing Composer (Latest) ..."
    sleep 5
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php --install-dir=/usr/bin --filename=composer


elif [ "$choice" == "2" ]; then

    echo -e "Okay!"
    sleep 5


else

    printf "${RD}Invalid choice!${NC}🙂\n" && sleep 3
    clear && composer_selection

fi
}

composer_selection
sleep 2
##
clear
printf "${GN}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
|                   ## Installation Has Been Completed ##                   |
|                                                                           |
|   Please Run => mysql_secure_installation <= To Configure MariaDB/MySql   |
|                                                                           |
|   Please upload your files to /var/www/html > ( For Apache/Nginx )        |
|                                                                           |
|                                  ${YO}Enjoy!                         ${GN}          |
|                                                                           |
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#${NC}\n"
endTime=`date +%s`
((outTime=($endTime-$startTime)/60))
echo -e "Time consumed:\033[32m $outTime \033[0mMinute!"
###openlitespeed##
ols
##################
