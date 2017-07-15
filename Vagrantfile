Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box"
  config.vm.provision :shell, :path => "vm_provision/provision-ubuntu-14.04.sh"
  # for socket io
  config.vm.network "forwarded_port", guest: 8080, host: 3000
  config.vm.network "private_network", ip: "10.0.0.10"
  config.vm.synced_folder "./", "/var/www", id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50", "--cpus", "2"]
    vb.memory = 1024
  end
end
