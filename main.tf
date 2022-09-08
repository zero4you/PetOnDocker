terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0_AgAAAAA8MCzQAATuwQAAAADN-NjICBJzIIh6TNOB1qvJJg7OIr-mnd0"
  cloud_id  = "b1g1rjnamnft86q5fuha"
  folder_id = "b1g6bg4vssj7qttmmf5k"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "webserver1" {
  name = "webserver1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8uoiksr520scs811jl" # Ubuntu 22.04 LTS
      size = 25
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("/home/alik/PetOnDocker/meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


data "template_file" "inventory" {
  template = file("./_templates/inventory.tpl")
  
  vars = {
    host = join("", [yandex_compute_instance.webserver1.name, " ansible_host=", yandex_compute_instance.webserver1.network_interface.0.nat_ip_address])
  }
}

resource "local_file" "save_inventory" {
  content  = data.template_file.inventory.rendered
  filename = "./inventory"
}


output "Внутренний_IP_хоста_webserver1" {
  value = yandex_compute_instance.webserver1.network_interface.0.ip_address
}

output "Внешний_IP_хоста_webserver1" {
  value = yandex_compute_instance.webserver1.network_interface.0.nat_ip_address
}
