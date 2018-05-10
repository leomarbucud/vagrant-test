Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://github.com/sepetrov/trusty64/releases/download/v0.0.5/trusty64.box"
  config.vm.provision :shell, :path => "vm_provision/provision-ubuntu-14.04.sh"
  # for socket io
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  # for polymer cli
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "private_network", ip: "10.0.0.10"
  # config.vm.network "public_network"

  config.vm.synced_folder "./", "/var/www",
    id: "vagrant-root",
    type: "nfs",
    # rsync__exclude: [
    #   ".git/",
    #   "./thegrid/storage/oauth-private.key",
    #   "./thegrid/storage/oauth-public.key",
    #   "./thegrid/public/storage",
    # ],
    # owner: "www-data",
    # group: "www-data",
    mount_options: ['rw', 'vers=3', 'tcp'],
    linux__nfs_options: ['rw','no_subtree_check','all_squash','async']
    # mount_options: ["dmode=775,fmode=664"]

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50", "--cpus", "2"]
    vb.memory = 1024
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/ —timesync-set-threshold", 1000 ]
  end
end
