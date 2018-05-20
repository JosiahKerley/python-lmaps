# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "iknite/trusty64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  config.vm.provision "shell", inline: <<-SHELL
sudo bash << 'BASH'
cd /vagrant
#sed -i '/vagrant/d' /root/.bashrc'
bash -c 'echo "cd /vagrant" >> /root/.bashrc'
./configure
make
make install
BASH
  SHELL
end