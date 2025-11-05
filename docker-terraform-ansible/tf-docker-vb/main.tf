terraform {
  required_providers {
    virtualbox = {
      source = "shekeriev/virtualbox"
    }
  }
}

provider "virtualbox" {
  delay      = 60
  mintimeout = 5
}

resource "virtualbox_vm" "AL96-Docker" {
  name   = "alma-9.6"
  image  = "https://app.vagrantup.com/shekeriev/boxes/almalinux-9.6/versions/0.1/providers/virtualbox.box"
  cpus   = 1
  memory = "2048 mib"

  #For Internet NAT adapter
  network_adapter {
    type   = "nat"
    device = "IntelPro1000MTDesktop"
  }

  #For SSH Host-only adapter
  network_adapter {
    type = "hostonly"
    device = "IntelPro1000MTDesktop"
    host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }

  # Upload the script for docker setup to the VM
  provisioner "file" {
    source      = "docker-setup-2.sh"
    destination = "/home/vagrant/docker-setup-2.sh"

    connection {
      type     = "ssh"
      user     = "vagrant"
      password = "vagrant"
      host     = self.network_adapter[1].ipv4_address
      timeout  = "5m"
    }
  }

  #Upload the script for additional setup + running the app to the VM
  provisioner "file" {
    source = "extra-setup.sh"
    destination = "/home/vagrant/extra-setup.sh"

    connection {
      type = "ssh"
      user = "vagrant"
      password = "vagrant"
      host = self.network_adapter[1].ipv4_address
      timeout = "5m"
    }
  }


  # Run the scripts on the VM
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/vagrant/docker-setup-2.sh",
      "sudo chmod +x /home/vagrant/extra-setup.sh",
      "sudo /home/vagrant/docker-setup-2.sh",
      "sudo /home/vagrant/extra-setup.sh"
    ]

    connection {
      type     = "ssh"
      user     = "vagrant"
      password = "vagrant"
      host     = self.network_adapter[1].ipv4_address
      timeout  = "5m"
    }
  }
}

output "IPAddress_url" {
  value = "http://${virtualbox_vm.AL96-Docker.network_adapter[1].ipv4_address}:8080"
}

