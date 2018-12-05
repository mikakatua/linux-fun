MAX_STATIONS = 20
BOX_NAME = "generic/rhel7"
BOX_VERSION = "1.8.48"

Vagrant.configure("2") do |config|

  config.vm.define "server1" do |server|
    server.vm.box = BOX_NAME
    server.vm.box_version = BOX_VERSION
    server.vm.network "public_network", ip: "10.100.0.254"
    server.vm.synced_folder ".", "/vagrant"
    server.vm.provision "shell", path: "setup.sh", args: "server1"
    server.vm.provider :virtualbox do |vb|
      vb.name = "server1"
      vb.memory = 512
      vb.cpus = 1
    end
  end

  (1..MAX_STATIONS).each do |i|
    config.vm.define "station#{i}" do |station|
      station.vm.box = BOX_NAME
      station.vm.box_version = BOX_VERSION
      station.vm.network "public_network", ip: "10.100.0.#{i}"
      station.vm.provision "shell", path: "https://raw.githubusercontent.com/mikakatua/linux-fun/master/setup.sh", args: "station#{i}"
      station.vm.provider :virtualbox do |vb|
        vb.name = "station#{i}"
        vb.memory = 512
        vb.cpus = 1
      end
    end
  end
end
