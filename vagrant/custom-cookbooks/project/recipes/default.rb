include_recipe "database::mysql"

python_pip "psycopg2" do
  action :install
end

python_pip "uwsgi" do
  action :install
end

postgresql_connection_info = {:host => "127.0.0.1",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

# Create postgres user
postgresql_database_user node['project']['database_user'] do
  connection postgresql_connection_info
  password node['project']['database_password']
  action :create
end

# Create postgres database
postgresql_database node['project']['database_name'] do
  connection postgresql_connection_info
  owner node['project']['database_user']
  action :create
end

# Create local_settings.py file
template "#{node['project']['dir']}/project/local_settings.py" do
  source "project.local_settings.erb"
  mode 00644
  variables(
    :database_name => node['project']['database_name'],
    :database_user => node['project']['database_user'],
    :database_password => node['project']['database_password'],
    :static_dir => node['project']['static_dir'],
    :static_servername => node['project']['static_servername']
  )
  notifies :reload, 'service[nginx]'
end

# Create nginx udata site
template "#{node['nginx']['dir']}/sites-available/project" do
  source "project.nginx.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :socket => "unix://#{node['project']['socket']}",
    :servername => node['project']['servername'],
    :static_dir => node['project']['static_dir'],
    :static_servername => node['project']['static_servername']
  )
  notifies :reload, 'service[nginx]'
end

# Set up the project
bash "setup project" do
  user "root"
  cwd node['project']['dir']
  code <<-EOH
  ./setup.sh
  EOH
  only_if { ::File.exists?("#{node['project']['dir']}/setup.sh") }
end

# Create supervisor service
supervisor_service "project-web" do
  action :enable
  command "uwsgi --socket #{node['project']['socket']} --file project/wsgi.py -C --touch-reload /tmp/project-reload #{node['project']['uwsgi_extra']}" #  --python-autoreload --enable-threads" # 
  autostart true
  directory node['project']['dir']
  notifies :reload, 'service[nginx]'
end

nginx_site 'project' do
  enable true
end
