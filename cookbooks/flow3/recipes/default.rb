execute "apt-get update"
execute "apt-get -y -q upgrade && apt-get -y -q dist-upgrade"

packages = ["php5", "php5-cli", "php-pear", "php5-mysql"]

packages.each do |p|
  package p
end

execute "pear upgrade-all"

directory "/var/www/" do
	action :create
	owner "www-data"
  	group "www-data"
  end

# Execute a block
execute "wget http://sourceforge.net/projects/flow3/files/latest/download -O /var/www/flow3.tar.bz2" do
  not_if do
    File.exists?("/var/www/flow3.tar.bz2")
  end
end

execute "cd /var/www/ && sudo tar xjf flow3.tar.bz2 --strip-components=1" do
  only_if do
    File.exists?("/var/www/flow3.tar.bz2")
  end
end
 
 execute "cd /var/www/ && sudo ./flow3 core:setfilepermissions vagrant www-data www-data" do
  only_if do
    File.exists?("/var/www/flow3.tar.bz2")
  end
end


file "/var/www/flow3.tar.bz2" do
  action :delete
end

cookbook_file "/etc/apache2/sites-enabled/000-default" do
  source "000-default" # this is the value that would be inferred from the path parameter
  mode "0644"
end

cookbook_file "/var/www/Configuration/Settings.yaml" do
  source "Settings.yaml" # this is the value that would be inferred from the path parameter
  mode "0644"
end

service "apache2" do
	action :restart
end