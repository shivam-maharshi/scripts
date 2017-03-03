sudo touch /etc/yum.repos.d/logstash.repo
echo "[logstash-2.2]
name=logstash repository for 2.2 packages
baseurl=http://packages.elasticsearch.org/logstash/2.2/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
" > /etc/yum.repos.d/logstash.repo
yum -y install logstash
