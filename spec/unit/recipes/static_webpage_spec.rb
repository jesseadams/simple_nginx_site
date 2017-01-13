require 'spec_helper'

describe 'simple_nginx_site::static_webpage' do
  include_context 'mocked_chef_run'

  it 'creates the root directory' do
    expect(chef_run).to create_directory('/var/www/static_webpage').with(
      recursive: true
    )
  end

  it 'creates the static default content' do
    expect(chef_run).to create_cookbook_file('/var/www/static_webpage/index.html').with(
      source: 'index.html'
    )
  end

  it 'generates the nginx configuration for the static webpage' do
    expect(chef_run).to create_template('/etc/nginx/sites-enabled/static_webpage').with(
      source: 'static_webpage.erb',
      variables: { root_dir: '/var/www/static_webpage' }
    )

    resource = chef_run.template('/etc/nginx/sites-enabled/static_webpage')
    expect(resource).to notify('service[nginx]').to(:reload).delayed
  end
end
