resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.cidr]
}

resource "yandex_vpc_security_group" "rmq_sg" {
  name       = "rmq-security-group"
  network_id = yandex_vpc_network.vpc.id

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    from_port      = 22
    to_port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    from_port      = 15672
    to_port        = 15672
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = [var.cidr]
  }

  ingress {
    protocol       = "TCP"
    from_port      = 5672
    to_port        = 5672
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    from_port      = 4369
    to_port        = 4369
    v4_cidr_blocks = [var.cidr]
  }

  ingress {
    protocol       = "TCP"
    from_port      = 25672
    to_port        = 25672
    v4_cidr_blocks = [var.cidr]
  }
}

resource "yandex_compute_instance" "rmq" {
  count = 2

  name = "rmq${count.index + 1}"
  zone = var.zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    security_group_ids = [yandex_vpc_security_group.rmq_sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "stez:${file(var.ssh_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "local_file" "ansible_inventory" {
  filename = "./ansible/inventory.ini"
  content  = <<EOT
[rmq]
rmq1 ansible_host=${yandex_compute_instance.rmq[0].network_interface[0].nat_ip_address} private_ip=${yandex_compute_instance.rmq[0].network_interface[0].ip_address} ansible_user=stez
rmq2 ansible_host=${yandex_compute_instance.rmq[1].network_interface[0].nat_ip_address} private_ip=${yandex_compute_instance.rmq[1].network_interface[0].ip_address} ansible_user=stez

[rmq:vars]
ansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_ssh_private_key_file=${replace(var.ssh_key_path, ".pub", "")}
ansible_python_interpreter=/usr/bin/python3
EOT
}
