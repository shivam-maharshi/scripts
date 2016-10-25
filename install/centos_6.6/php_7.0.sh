sudo yum install git gcc gcc-c++ libxml2-devel pkgconfig openssl-devel bzip2-devel curl-devel libpng-devel libjpeg-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel mariadb-devel aspell-devel recode-devel autoconf bison re2c libicu-devel
sudo mkdir /usr/local/php7
git clone https://github.com/php/php-src.git
cd php-src
git checkout PHP-7.0.2

sudo ./buildconf --force

sudo ./configure --prefix=/usr/local/php7 \
    --with-config-file-path=/usr/local/php7/etc \
    --with-config-file-scan-dir=/usr/local/php7/etc/conf.d \
    --enable-bcmath \
    --with-bz2 \
    --with-curl \
    --enable-filter \
    --enable-fpm \
    --with-gd \
    --enable-gd-native-ttf \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --enable-intl \
    --enable-mbstring \
    --with-mcrypt \
    --enable-mysqlnd \
    --with-mysql-sock=/var/lib/mysql/mysql.sock \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite \
    --disable-phpdbg \
    --disable-phpdbg-webhelper \
    --enable-opcache \
    --with-openssl \
    --enable-simplexml \
    --with-sqlite3 \
    --enable-xmlreader \
    --enable-xmlwriter \
    --enable-zip \
    --enable-maintainer-zts \
    --with-tsrm-pthreads \
    --with-zlib

sudo make clean
sudo make -j8    
sudo make install
    
sudo mkdir /usr/local/php7/etc/conf.d
sudo cp -v ./php.ini-production /usr/local/php7/lib/php.ini
sudo cp -v ./sapi/fpm/www.conf /usr/local/php7/etc/php-fpm.d/www.conf
sudo cp -v ./sapi/fpm/php-fpm.conf /usr/local/php7/etc/php-fpm.conf

sudo touch /usr/local/php7/etc/conf.d/modules.ini
sudo echo "zend_extension=opcache.so" > /usr/local/php7/etc/conf.d/modules.ini
    
