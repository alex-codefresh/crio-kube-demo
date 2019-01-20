VAGRANTFILE_API_VERSION = "2"

cluster = {
  "master-crio-1" => { :ip => "192.168.33.10", :cpus => 2, :mem => 1024 },
  "node-crio-1" => { :ip => "192.168.33.20", :cpus => 2, :mem => 2048 }
}
 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  cluster.each_with_index do |(hostname, info), index|

    config.vm.define hostname do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        config.vm.box = "ubuntu/bionic64"
        config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/bionic64/versions/20190116.0.0/providers/virtualbox.box"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]
      end # end provider
    end # end config

  end # end cluster
end