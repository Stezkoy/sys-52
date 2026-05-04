resource "yandex_compute_instance" "neto_web_a" {
  name        = "neto-web-a"
  hostname    = "neto-web-a"
  description = "Веб-сервер в зоне ru-central1-a"
  platform_id = "standard-v2"
  zone        = var.zones[0]

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
    subnet_id          = yandex_vpc_subnet.neto_private_a.id
    security_group_ids = [yandex_vpc_security_group.neto_web_sg.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      users:
        - name: stez
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.ssh_key_path)}
    EOF
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}

resource "yandex_compute_instance" "neto_web_b" {
  name        = "neto-web-b"
  hostname    = "neto-web-b"
  description = "Веб-сервер в зоне ru-central1-b"
  platform_id = "standard-v2"
  zone        = var.zones[1]

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
    subnet_id          = yandex_vpc_subnet.neto_private_b.id
    security_group_ids = [yandex_vpc_security_group.neto_web_sg.id]
  }

  metadata = {
    user-data = local.default_cloud_config
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}

resource "yandex_compute_instance" "neto_zabbix" {
  name        = "neto-zabbix"
  hostname    = "neto-zabbix"
  description = "Сервер мониторинга Zabbix"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.neto_public_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.neto_zabbix_sg.id]
  }

  metadata = {
    user-data = local.default_cloud_config
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}

resource "yandex_compute_instance" "neto_elasticsearch" {
  name        = "neto-elasticsearch"
  hostname    = "neto-elasticsearch"
  description = "Сервер Elasticsearch для хранения логов"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.neto_private_a.id
    security_group_ids = [yandex_vpc_security_group.neto_elasticsearch_sg.id]
  }

  metadata = {
    user-data = local.default_cloud_config
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}

resource "yandex_compute_instance" "neto_kibana" {
  name        = "neto-kibana"
  hostname    = "neto-kibana"
  description = "Веб-интерфейс Kibana для просмотра логов"
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
    security_group_ids = [yandex_vpc_security_group.neto_kibana_sg.id]
  }

  metadata = {
    user-data = local.default_cloud_config
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}