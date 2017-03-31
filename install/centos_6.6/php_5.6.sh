yum remove php php-cli php-common php-gd php-ldap php-mysql php-odbc php-pdo php-pear php-pecl-apc php-pecl-memcache php-pgsql php-soap php-xml php-xmlrpc
yum -y update
yum -y install epel-release
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
wget https://centos6.iuscommunity.org/ius-release.rpm
rpm -Uvh ius-release*.rpm
yum -y update
yum -y install php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath php56u-pecl-apcu
