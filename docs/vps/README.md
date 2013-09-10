Reloved Virtual Private Server Setup
=======

# System

OS: CentOS 6.2 64b
RAM: 1024 MB
HDD: 48896 MB
Provider: linode.com

# Setup time-zone

    cd /etc
    rm localtime
    ln -sf /usr/share/zoneinfo/Etc/GMT localtime

# Setup users

* api: Dh434asdfX
* api-dev: Rn290xa0s4
* www: Dh434asdfX
* www-dev: Rn290xa0s4
* nginx: XeRfg0204Z

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

## Modify user_list ("vi userlist"):

    www
    www-dev

## Generate a security certificate:

    /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout vsftpd.pem -out vsftpd.pem
    
    Country Name (2 letter code) [XX]:UK
    State or Province Name (full name) []:London
    Locality Name (eg, city) [Default City]:London
    Organization Name (eg, company) [Default Company Ltd]:Reloved
    Organizational Unit Name (eg, section) []:FTP
    Common Name (eg, your name or your server's hostname) []:relovedapp.co.uk
    Email Address []:webmaster@relovedapp.co.uk

## Finally, restart the service:

    /etc/init.d/vsftpd restart

# Setup SSH

## Modify /etc/ssh/sshd_config ("vi /etc/ssh/sshd_config")

    # Prevent root logins:
    PermitRootLogin no
    
    # Add the following
    AllowUsers www www-dev api

## Finally, restart the service:

    service sshd restart
