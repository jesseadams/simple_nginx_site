include_recipe 'nginx::default'

root_dir = '/var/www/static_webpage'

directory root_dir do
  recursive true
end

cookbook_file File.join(root_dir, 'index.html') do
  source 'index.html'
end

template '/etc/nginx/sites-enabled/static_webpage' do
  source 'static_webpage.erb'
  variables root_dir: root_dir
  notifies :reload, 'service[nginx]'
end
