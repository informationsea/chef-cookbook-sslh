sslh_url = "http://www.rutschle.net/tech/sslh-v#{node['sslh']['source']['version']}.tar.gz"
src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/sslh-v#{node['sslh']['source']['version']}.tar.gz"
src_dirpath = "#{Chef::Config['file_cache_path'] || '/tmp'}/sslh-v#{node['sslh']['source']['version']}"
install_dirpath = node['sslh']['prefix']

%w(libconfig-devel).each do |pkg|
  package pkg do
    action :install
  end
end

user node['sslh']['user'] do
  action :create
  home '/var/sslh'
  system true
  shell '/sbin/nologin'
end

remote_file sslh_url do
  checksum node['sslh']['source']['checksum']
  path src_filepath
  backup false
end

bash 'unarchive_source' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
  EOH
  not_if { ::File.directory?(src_dirpath) }
end

bash 'compile_sslh' do
  cwd src_dirpath
  code <<-EOH
make  PREFIX=#{install_dirpath}
EOH
  creates "#{src_dirpath}/sslh-fork"
end

#bash 'install_ssl' do
#  cwd src_dirpath
#  code <<-EOH
#make install PREFIX=#{install_dirpath}
#EOH
#  creates "${install_dirpath}/sbin/sslh"
#end

bash 'install_ssl-select' do
  cwd src_dirpath
  code <<-EOH
cp #{src_dirpath}/sslh-select #{install_dirpath}/sbin/
EOH
  creates '/usr/local/sbin/sslh-select'
end

bash 'install_ssl-init' do
  cwd src_dirpath
  code <<-EOH
cp #{src_dirpath}/scripts/etc.rc.d.init.d.sslh.centos /etc/rc.d/init.d/sslh
EOH
  creates '/etc/rc.d/init.d/sslh'
end

bash 'install_ssl-default' do
  cwd src_dirpath
  code <<-EOH
cp #{src_dirpath}/scripts/etc.default.sslh  /etc/default/sslh
EOH
  creates '/etc/default/sslh'
end

template '/etc/sysconfig/sslh' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  notifies :restart, 'service[sslh]'
end

template '/etc/sslh.cfg' do
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, 'service[sslh]'
end

template '/etc/rsyslog.d/sslh.conf' do
  source 'rsyslog-sslh.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, 'service[rsyslog]'
end

template '/etc/logrotate.d/sslh' do
  source 'logrotate-sslh.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

directory '/var/run/sslh' do
  user 'sslh'
  group 'sslh'
  mode 0755
  action :create
end


service 'sslh' do
  supports status: true, restart: true
  action [:start, :enable]
end

service 'rsyslog' do
  supports status: true, restart: true
  action [:start, :enable]
end
