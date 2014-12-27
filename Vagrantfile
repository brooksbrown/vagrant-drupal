VAGRANTFILE_API_VERSION = "2"

DRUPAL_DOCROOT_PATH = ".."

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "192.168.10.5"
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.synced_folder DRUPAL_DOCROOT_PATH, "/vagrant", type: "nfs"
  config.vm.synced_folder "salt/roots/", "/srv/salt/"

  config.vm.provider :virtualbox do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    v.memory = 1024
  end 

  config.vm.provision :salt do |salt|

    # Apache Pillar
    #
    salt.pillar({
      "apache" => {
        "sites" => {
          "localhost" => {
            "ServerName" => "localhost",
            "DocumentRoot" => "/vagrant/docroot",
            "Directory" => {
              "/vagrant/docroot" => {
                "Options" => "Indexes FollowSymLinks MultiViews",
                "AllowOverride" => "All"
              }
            }
          }
        }
      }
    })

    # Mysql Pillar
    #
    salt.pillar({
      "mysql" => {
        "server" => {
          "root_password" => "somepass",
        },
      }
    })

    # Mysql-Basic-Management Pillar
    #
    salt.pillar({
      "mysql-basic-management" => {
        "databases" => { 
          "db" => {
            "user" => "vagrant",
            "pass" => "vagrant"
          }
        }
      }
    })

    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
  end

  config.vm.provision "shell" do |s|
    s.path = "vagrant-provision.sh"
  end

end

