# -*- mode: ruby -*-
# vi: set ft=ruby :

update_ubuntu = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo sed -i.bak '/deb-src/d' /etc/apt/sources.list
  sudo aptitude update 
  touch /tmp/up
fi
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define :plex do |node|
    device = ENV['VAGRANT_BRIDGE'] || 'eth0'
    env  = ENV['PUPPET_ENV'] || 'dev'

    node.vm.box = 'ubuntu-15.10_puppet-3.8.2' 
    node.vm.network :public_network, :bridge => device , :dev => device, :mac => '52:54:00:b7:42:e4'
    node.vm.hostname = 'plex.local'
  
    node.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 2048, '--cpus', 2]
    end

    node.vm.provider :libvirt do |domain, o|
      domain.uri = 'qemu+unix:///system'
      domain.host = 'plex.local'
      domain.memory = 2048
      domain.cpus = 2
      domain.storage_pool_name = 'daemon'
      o.vm.synced_folder './', '/vagrant', type: 'nfs'
    end


    node.vm.provision :shell, :inline => update_ubuntu
    node.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'default.pp'
      puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
    end
  end

end
