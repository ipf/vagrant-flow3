execute "apt-get update"
execute "apt-get -y -q upgrade && apt-get -y -q dist-upgrade"

packages = ["php5", "php5-cli", "php-pear"]

packages.each do |p|
  package p
end

execute "pear upgrade-all"

directory "/var/www/" do
	action :create
	owner "www-data"
  	group "www-data"
  end

execute "wget http://sourceforge.net/projects/flow3/files/latest/download -O /var/www/flow3.tar.bz2"
execute "cd /var/www/ && sudo tar xjf flow3.tar.bz2 --strip-components=1"
execute "cd /var/www/ && sudo ./flow3 core:setfilepermissions vagrant www-data www-data"

# execute "cp /vagrant/files/000-default /etc/apache2/sites-enabled"

service "apache2" do
	notifies :restart, "service[apache2]", :immediately
end