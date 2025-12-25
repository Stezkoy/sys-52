resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.cidr]
}

resource "yandex_compute_instance" "vm" {
  count = 2

  name = "vm-${count.index + 1}"
  zone = var.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
    core_fraction = var.vm_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "stez:${file(var.ssh_key_path)}"
  }
}

resource "yandex_lb_target_group" "tg" {
  name = "neto-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.vm
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  name = "neto-balancer"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.tg.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
      interval            = 10
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
}

resource "local_file" "ansible_inventory" {
  filename = "./ansible/inventory.ini"
  content = <<EOT
[web_servers]
%{ for vm in yandex_compute_instance.vm ~}
${vm.name} ansible_host=${vm.network_interface[0].nat_ip_address} ansible_user=stez
%{ endfor ~}

[all:vars]
ansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_ssh_private_key_file=${replace(var.ssh_key_path, ".pub", "")}
ansible_python_interpreter=/usr/bin/python3
EOT
  depends_on = [yandex_compute_instance.vm]
}