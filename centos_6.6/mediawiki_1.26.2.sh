sudo wget "https://releases.wikimedia.org/mediawiki/1.26/mediawiki-1.26.2.tar.gz"
sudo tar -xvzf mediawiki-1.26.2.tar.gz
sudo mv mediawiki-1.26.2 wiki
sudo chmod 777 -R wiki
php /var/www/wiki/maintenance/install.php --dbname testwiki --dbserver 127.0.0.1 --dbtype mysql --dbuser root --email shivam.maharshi@gmail.com --pass "shivam123" --installdbuser root --scriptpath /wiki --admin shivam
