# rubocop:disable all
describe port 80 do
  it { should be_listening }
end

describe sysv_service 'nginx' do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/nginx/sites-enabled/static_webpage') do
  its('content') { should eq <<-EOF
server {
  listen 80 default_server;

  root /var/www/static_webpage;
  index index.html index.htm;

  # Make site accessible from http://localhost/
  server_name localhost;

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    try_files $uri $uri/ =404;
  }
}
  EOF
  }
end

describe file('/var/www/static_webpage/index.html') do
  its('content') { should match /Automation for the People/ }
end

describe command('curl http://localhost') do
  its(:stdout) { should match /Automation for the People/ }
end
