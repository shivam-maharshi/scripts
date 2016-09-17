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
    path => [ "/Users/library/development/benchmarking/resources/*.txt" ]
    type => "core2"
    start_position => "beginning"
  }
}

filter {
  if [type] == "collectl" {
    csv {
      separator => " "
    }

    mutate {

      remove_field => [column4, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column26, column27, column28, column29, column30, column31, column32, column33, column36, column37, column38, column39]

      rename => ["column1", "DATE", "column2", "TIME", "column3", "CPU_USR", "column5", "CPU_SYS", "column24", "NET_RX_KB", "column25", "NET_TX_KB", "column34", "DSK_RD_KB", "column35", "DSK_WT_KB"]

      convert => {
                   "CPU_USR" => "integer"
                   "CPU_SYS" => "integer"
                   "NET_RX_KB" => "integer"
                   "NET_TX_KB" => "integer"
                   "DSK_RD_KB" => "integer"
                   "DSK_WT_KB" => "integer"
                 }
    }
  }
}

output {
  elasticsearch {
    action => "index"
    hosts => "127.0.0.1"
    index => "logstash-%{+YYYY.MM.dd}"
    workers => 1
  }
  #stdout {
  #  codec => rubydebug
  #}}
}
 
# eof
EOF

elasticsearch
