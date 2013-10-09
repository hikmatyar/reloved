Reloved Virtual Private Server Setup
=======

# System

* OS: CentOS 6.2 64b
* RAM: 1024 MB
* HDD: 48896 MB
* Provider: linode.com

# Users and passwords

* api: Dh434asdfX
* api-dev: Rn290xa0s4
* www: Dh434asdfX
* www-dev: Rn290xa0s4
* nginx: XeRfg0204Z

# Setup time-zone

    cd /etc
    rm localtime
    ln -sf /usr/share/zoneinfo/Etc/GMT localtime

# Setup users

	groupadd web
	groupadd web-dev

	/usr/sbin/useradd nginx
	passwd nginx
	usermod -a -G web nginx
	usermod -a -G web-dev nginx

	/usr/sbin/useradd api
	passwd api
	chmod g+rx /home/api
	usermod -a -G web api
	usermod -a -G api nginx

	/usr/sbin/useradd api-dev
	passwd api-dev
	chmod g+rx /home/api-dev
	usermod -a -G web-dev api-dev
	usermod -a -G api-dev nginx

	/usr/sbin/useradd -g web www
	passwd www
	chmod g+rx /home/www
	su www
	cd /home/www
	mkdir -p httpdocs/cgi-bin
	exit

	/usr/sbin/useradd -g web-dev www-dev
	passwd www-dev
	chmod g+rx /home/www-dev
	su www-dev
	cd /home/www-dev
	mkdir -p httpdocs/cgi-bin
	cd httpdocs
	echo "reloved:QFFLkbMwCCzrY" > .htpasswd
	# user: "reloved", "password: "devoler"
	echo "AuthName \"Reloved Zone\"" > .htaccess
	echo "AuthType Basic" >> .htaccess
	echo "AuthUserFile /home/www-dev/.htpasswd" >> .htaccess
	echo "AuthGroupFile /dev/null" >> .htaccess
	echo "require valid-user" >> .htaccess
	exit

# Setup package management

    yum repolist
    yum makecache
    yum -y update
    
# Setup development tools

    yum install -y gcc gcc-c++
    yum install -y rpm-build redhat-rpm-config
    yum install -y make libtool
    yum install -y java-1.6.0-openjdk
    yum install -y openssl-devel openssl-static
    yum install -y python-devel python-setuptools
    yum install -y perl-devel
    yum install -y ruby
    yum install -y libxml2-devel
    yum install -y scons
    yum install -y vsftpd
    yum install -y mysql mysql-server mysql-devel
    yum install -y subversion
    yum install -y gc git
    updatedb
    
    rpm -ivh http://mirror.cogentco.com/pub/linux/epel/6/x86_64/epel-release-6-8.noarch.rpm
    yum install -y php php-xml php-mysql php-mbstring php-pdo php-pecl-memcache
    yum install nginx
    yum install spawn-fcgi
    yum install ocaml ocaml-camlp4-devel
    easy_install supervisor

# Setup FTP

## Create vsftpd.conf

    cd /etc/vsftpd
    cp vsftpd.conf vsftpd.conf.default

## Setup vsftpd.conf ("vsftpd.conf")

    anonymous_enable=NO
    local_enable=NO
    write_enable=YES
    chroot_local_user=YES
    chroot_list_enable=NO
    
    userlist_enable=YES
    userlist_deny=NO
    userlist_file=/etc/vsftpd/user_list
    ssl_enable=YES
    allow_anon_ssl=NO
    force_local_data_ssl=YES
    force_local_logins_ssl=YES
    ssl_tlsv1=YES
    ssl_sslv2=YES
    ssl_sslv3=YES
    rsa_cert_file=/etc/vsftpd/vsftpd.pem
    
    force_dot_files=NO
    hide_ids=YES

## Modify user_list ("vi userlist")

    www
    www-dev

## Generate a security certificate

    /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout vsftpd.pem -out vsftpd.pem
    
    Country Name (2 letter code) [XX]:UK
    State or Province Name (full name) []:London
    Locality Name (eg, city) [Default City]:London
    Organization Name (eg, company) [Default Company Ltd]:Reloved
    Organizational Unit Name (eg, section) []:FTP
    Common Name (eg, your name or your server's hostname) []:relovedapp.co.uk
    Email Address []:webmaster@relovedapp.co.uk

## Finally, restart the service

    /etc/init.d/vsftpd restart

# Setup SSH

## Modify /etc/ssh/sshd_config ("vi /etc/ssh/sshd_config")

    # Prevent root logins:
    PermitRootLogin no
    
    # Add the following
    AllowUsers www www-dev api

## Finally, restart the service

    service sshd restart

# Setup MySQL

## Initialize MySQL

    /etc/init.d/mysqld start
    /usr/bin/mysqladmin -u root password 'R30xaAss0X'
    mysql -p
    
## Create MySQL users and databases

    mysql> CREATE DATABASE reloved;
    mysql> CREATE DATABASE reloved_dev;
    mysql> CREATE USER 'www'@'localhost' IDENTIFIED BY 'Bv34ka20xQ';
    mysql> CREATE USER 'www-dev'@'localhost' IDENTIFIED BY 'Er0xAa3ecs';
    mysql> GRANT ALL PRIVILEGES ON reloved.* TO 'www'@'localhost' WITH GRANT OPTION;
    mysql> GRANT ALL PRIVILEGES ON reloved_dev.* TO 'www-dev'@'localhost' WITH GRANT OPTION;
    mysql> exit
    
## Close direct web access to the database (open by default)

    /sbin/iptables -A INPUT -p tcp -i eth1 ! -s 127.0.0.1 --dport 3306 -j DROP
    /sbin/service iptables save

# Setup Fast-CGI

    rm /etc/rc.d/rc5.d/K20spawn-fcgi

# Install NodeJS

Download the latest installer from http://nodejs.org/download/

    curl -o node.tar.gz http://nodejs.org/dist/v0.10.18/node-v0.10.18.tar.gz
    gunzip node.tar.gz
    tar xvf node.tar
    cd node-v0.10.18
    ./configure
    make
    make install
    cd ..
    rm -fr node*

# Install HaXe

	cd /opt
	git clone git://github.com/HaxeFoundation/haxe.git
	cd haxe
	git submodule init
	git submodule update
	make
	make install
	
	haxelib setup
	> Hit enter for default (/usr/lib/haxe/lib) [ENTER]
	
	haxelib install nodejs
	haxelib git saffron https://github.com/janekp/saffron.git master src
	npm install -g express
	npm install -g watch-compile
	npm install -g mysql generic-pool mapstrace formidable@latest
	npm install -g jasmine-node winston send

# Setup nginx

    chown -R root:nginx /var/lib/php
    mkdir -p /var/nginx/cache/

Copy nginx configuration files from "/docs/vps/nginx" to "/etc/nginx"

## Finally, restart the service

    /etc/init.d/nginx restart

# Setup github for automatic deployment

	cd /home/api
	su api
	mkdir .ssh
	cd .ssh
	ssh-keygen -t rsa -C "<EMAIL ADDRESS IN GITHUB>"
	# No passphrase (press ENTER)
	exit
	
	cd /home/api-dev
	su api-dev
	mkdir .ssh
	cd .ssh
	ssh-keygen -t rsa -C "<EMAIL ADDRESS IN GITHUB>"
	# No passphrase (press ENTER)
	exit

Copy the contents of "/home/api/.ssh/id_rsa.pub" and "/home/api-dev/.ssh/id_rsa.pub" to github.com

## Checkout git

	cd /home/api
	su api
	mkdir -p log/index
	git clone git@github.com:hikmatyar/reloved.git git
	exit
	
	cd /home/api-dev
	su api-dev
	mkdir -p log/index
	git clone git@github.com:hikmatyar/reloved.git git
	exit

# Setup supervisor

Copy supervisor configuration file from "/docs/vps/supervisor/supervisord.conf" to "/etc/supervisord.conf"

## Setup start-up scripts

Copy api start-up script from "/docs/vps/supervisor/api/supervisor-api.sh" to "/home/api/supervisor-api.sh"

Copy admin start-up script from "/docs/vps/supervisor/api/supervisor-admin.sh" to "/home/api/supervisor-admin.sh"

Copy agent start-up script from "/docs/vps/supervisor/api/supervisor-agent.sh" to "/home/api/supervisor-agent.sh"

Copy api-dev start-up script from "/docs/vps/supervisor/api-dev/supervisor-api.sh" to "/home/api-dev/supervisor-api.sh"

Copy supervisor start-up script from "/docs/vps/supervisor/supervisord.sh" to "/etc/init.d/supervisord"

Make scripts executable

	chmod 755 supervisor-*

## Finally, start the service

Move supervisord.sh to /etc/init.d/supervisord

    chmod 755 /etc/init.d/supervisord
    chkconfig --add supervisord
    mkdir -p /var/log/supervisor
    /etc/init.d/supervisord start
    