require 'spec_helper'

describe 'xml::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'installs the XML package' do
    expect(chef_run).to install_package('libxml2-dev')
    expect(chef_run).to install_package('libxslt-dev')
    expect(chef_run).to install_package('zlib1g-dev')
  end
end
