require 'serverspec'
require "docker"

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of CentOS" do
    expect(os_version).to match(/^CentOS Linux release 7/)
  end

  describe process('supervisord') do
    it { should be_running }
  end

  def os_version
    command("cat /etc/redhat-release").stdout
  end
end
