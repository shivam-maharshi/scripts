# Reference: https://sensuapp.org/docs/latest/installation/install-redis-on-rhel-centos.html
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum install redis
# Turn off auto start
/sbin/chkconfig redis off
pecl install redis
echo 'extension=redis.so' > /etc/php.ini
