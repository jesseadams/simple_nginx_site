require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'debian'
  config.version = '8.4'
end

RSpec.shared_context 'mocked_chef_run' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do
      stub_command('which nginx').and_return('/usr/sbin/nginx')
    end.converge(described_recipe)
  end
end
