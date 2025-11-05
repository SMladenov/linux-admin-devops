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

resource "virtualbox_vm" "vm1-Web" {
  name   = "alma-9.6-web"
  image  = "https://app.vagrantup.com/shekeriev/boxes/almalinux-9.6/versions/0.1/providers/virtualbox.box"
  cpus   = 1
  memory = "1024 mib"

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

# Upload the script for web setup to the VM
  provisioner "file" {
    source      = "web-setup.sh"
    destination = "/home/vagrant/web-setup.sh"

    connection {
      type     = "ssh"
      user     = "vagrant"
      password = "vagrant"
      host     = self.network_adapter[1].ipv4_address
      timeout  = "5m"
    }
  }

# Run the scripts on the VM
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/vagrant/web-setup.sh",
      "sudo /home/vagrant/web-setup.sh"
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

resource "virtualbox_vm" "vm2-DB" {

  #Add a dependency so the Web VM can be created first for proper IP assignment
  depends_on = [virtualbox_vm.vm1-Web]

  name   = "alma-9.6-db"
  image  = "https://app.vagrantup.com/shekeriev/boxes/almalinux-9.6/versions/0.1/providers/virtualbox.box"
  cpus   = 1
  memory = "1024 mib"

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

  #Upload the script for web setup to the VM
  provisioner "file" {
    source      = "db-setup.sh"
    destination = "/home/vagrant/db-setup.sh"

    connection {
      type     = "ssh"
      user     = "vagrant"
      password = "vagrant"
      host     = self.network_adapter[1].ipv4_address
      timeout  = "5m"
    }
  }

  # Run the scripts on the VM
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/vagrant/db-setup.sh",
      "sudo /home/vagrant/db-setup.sh"
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

output "IPAddress_url-web" {
  value = "http://${virtualbox_vm.vm1-Web.network_adapter[1].ipv4_address}:80"
}

output "IPAddress-db" {
  value = "http://${virtualbox_vm.vm2-DB.network_adapter[1].ipv4_address}"
}

