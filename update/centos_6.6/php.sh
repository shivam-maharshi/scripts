yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install http://rpms.remirepo.net/enterprise/remi-release-6.rpm
yum install yum-utils
yum-config-manager --enable remi-php70
yum update
php --version

sudo yum install php-pecl-zendopcache
