resource "yandex_vpc_security_group" "neto_web_sg" {
  name        = "neto-web-sg"
  description = "Правила для веб-серверов: HTTP из подсетей балансировщика, SSH от bastion"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP от ALB"
    port           = 80
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH от bastion"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "neto_zabbix_sg" {
  name        = "neto-zabbix-sg"
  description = "Правила для Zabbix: HTTP и доступ агентов"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP для веб-интерфейса Zabbix"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "Порт Zabbix-агентов"
    port           = 10050
    v4_cidr_blocks = [var.private_a_subnet_cidr, var.private_b_subnet_cidr, var.public_subnet_cidr]
  }
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }
  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "neto_elasticsearch_sg" {
  name        = "neto-elasticsearch-sg"
  description = "Правила для Elasticsearch: API порт и доступ от Kibana/Filebeat"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch API"
    port           = 9200
    v4_cidr_blocks = [var.public_subnet_cidr, var.private_a_subnet_cidr, var.private_b_subnet_cidr]
  }
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }
  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "neto_kibana_sg" {
  name        = "neto-kibana-sg"
  description = "Правила для Kibana: веб-интерфейс"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "Kibana UI"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }
  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}