resource "yandex_vpc_network" "neto_vpc" {
  name        = "neto-vpc"
  description = "Основная VPC для дипломного проекта"
}

resource "yandex_vpc_subnet" "neto_public_subnet" {
  name           = "neto-public-subnet"
  description    = "Публичная подсеть для сервисов с выходом в интернет"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.neto_vpc.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "neto_private_a" {
  name           = "neto-private-a"
  description    = "Приватная подсеть в зоне ru-central1-a"
  zone           = var.zones[0]
  network_id     = yandex_vpc_network.neto_vpc.id
  v4_cidr_blocks = [var.private_a_subnet_cidr]
  route_table_id = yandex_vpc_route_table.neto_nat_route.id
}

resource "yandex_vpc_subnet" "neto_private_b" {
  name           = "neto-private-b"
  description    = "Приватная подсеть в зоне ru-central1-b"
  zone           = var.zones[1]
  network_id     = yandex_vpc_network.neto_vpc.id
  v4_cidr_blocks = [var.private_b_subnet_cidr]
  route_table_id = yandex_vpc_route_table.neto_nat_route.id
}

resource "yandex_vpc_gateway" "neto_nat_gateway" {
  name        = "neto-nat-gateway"
  description = "NAT-шлюз для доступа приватных ВМ в интернет"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "neto_nat_route" {
  name        = "neto-nat-route"
  description = "Таблица маршрутов, направляющая трафик 0.0.0.0/0 на NAT-шлюз"
  network_id  = yandex_vpc_network.neto_vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.neto_nat_gateway.id
  }
}

resource "yandex_vpc_security_group" "neto_bastion_sg" {
  name        = "neto-bastion-sg"
  description = "Правила для bastion-хоста: только SSH"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "SSH из интернета"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "neto_bastion" {
  name        = "neto-bastion"
  hostname    = "neto-bastion"
  description = "Bastion-хост для доступа к приватным ВМ"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.neto_public_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.neto_bastion_sg.id]
  }

  metadata = {
    user-data = local.default_cloud_config
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}