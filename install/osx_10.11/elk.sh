cd ~/
brew install elasticsearch
brew install logstash
brew install wget
sudo wget https://download.elastic.co/kibana/kibana/kibana-3.1.3.tar.gz
sudo tar zxvf kibana-3.1.3.tar.gz

# Configure ELK Stack
sudo echo http.cors.allow-origin: "/.*/" > /usr/local/etc/elasticsearch/elasticsearch.yml
sudo echo http.cors.enabled: true > /usr/local/etc/elasticsearch/elasticsearch.yml
sudo -i 's/'cluster.name:/#cluster.name:/g' /usr/local/etc/elasticsearch/elasticsearch.yml
sudo echo "cluster.name: elasticsearch" > /usr/local/etc/elasticsearch/elasticsearch.yml
sudo mkdir /usr/local/logstash/
sudo mkdir /usr/local/logstash/patterns.d/
sudo mkdir $PWD/patterns.d/

sudo touch patterns.d/apache-error
sudo chmod 777 patterns.d/apache-error
sudo echo "APACHE_ERROR_LOG \[(?<timestamp>%{DAY:day} %{MONTH:month} %{MONTHDAY} %{TIME} %{YEAR})\] \[.*:%{LOGLEVEL:loglevel}\] \[pid %{NUMBER:pid}\] \[client %{IP:clientip}:.*\] %{GREEDYDATA:message}" > patterns.d/apache-error

sudo mkdir logstash
sudo touch logstash/logstash.conf

cat <<EOF | sudo tee $PWD/logstash/logstash.conf
# logstash config
 
input {
  file {
    path => [ "/var/log/*.log", "/var/log/messages", "/var/log/syslog" ]
    type => "syslog"
  }
  file {
    path => "/var/apache/logs/custom_log"
    type => "apache_access_log"
  }
  file {
    path => "/var/apache/logs/error_log"
    type => "apache_error_log"
  }
}
 
filter {
  if [type] == "apache_access_log" {
    mutate { replace => { "type" => "apache-access" } }
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
    }
    date {
      match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
    }
  }
  if [type] == "apache_error_log" {
    mutate { replace => { "type" => "apache-error" } }
    grok {
      patterns_dir => [ "/Users/username/logstash/patterns.d" ]
      match => [ "message", '%{APACHE_ERROR_LOG}' ]
      overwrite => [ "message" ]
    }
    if !("_grokparsefailure" in [tags]) {
      date {
        match => [ "timestamp", "EEE MMM dd HH:mm:ss.SSSSSS yyyy" ]
      }
    }
  }
  if [type] == "syslog" {
    grok {
      match => [ "message", "%{SYSLOGBASE2}" ]
    }
  }
}
 
output {
  elasticsearch { host => localhost }
  stdout { codec => rubydebug }
}
 
# eof
EOF

elasticsearch
