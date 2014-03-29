sslh_url = "http://www.rutschle.net/tech/sslh-#{node["sslh"]["source"]["version"]}.tar.gz"
src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/sslh-#{node['sslh']['source']['version']}.tar.gz"
src_dirpath = "#{Chef::Config['file_cache_path'] || '/tmp'}/sslh-#{node['sslh']['source']['version']}"

%w{libconfig-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file sslh_url do
  source   sslh_url
  checksum node['sslh']['source']['checksum']
  path     src_filepath
  backup   false
end

bash 'unarchive_source' do
  cwd  ::File.dirname(src_filepath)
  code <<-EOH
    tar zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
  EOH
  not_if { ::File.directory?("#{src_dirpath}") }
end

bash 'compile_sslh' do
  cwd "#{src_dirpath}"
  code <<-EOH
make
EOH
  creates "#{src_dirpath}/sslh-fork"
end

bash 'install_ssl' do
  cwd src_dirpath
  options = node[:sslh][:options]
  code <<-EOH
make install
EOH
  creates "/usr/local/sbin/sslh"
end

template "/etc/init.d/sslh" do
  owner "root"
  group "root"
  mode 0755
  action :create
  notifies :restart, 'service[sslh]'
end

service 'sslh' do
  supports :status => true, :restart => true
  action   [:start, :enable]
end
