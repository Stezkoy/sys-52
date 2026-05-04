resource "yandex_vpc_security_group" "neto_alb_sg" {
  name        = "neto-alb-sg"
  description = "Правила для ALB: HTTP из интернета"
  network_id  = yandex_vpc_network.neto_vpc.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP из интернета"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_alb_target_group" "neto_alb_tg" {
  name        = "neto-web-tg"
  description = "Целевая группа веб-серверов"

  target {
    subnet_id    = yandex_vpc_subnet.neto_private_a.id
    ip_address   = yandex_compute_instance.neto_web_a.network_interface[0].ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.neto_private_b.id
    ip_address   = yandex_compute_instance.neto_web_b.network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "neto_alb_bg" {
  name        = "neto-web-bg"
  description = "Backend-группа с healthcheck'ом на порт 80"

  http_backend {
    name             = "neto-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.neto_alb_tg.id]

    healthcheck {
      timeout  = "5s"
      interval = "10s"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "neto_http_router" {
  name        = "neto-http-router"
  description = "HTTP-роутер для сайта"
}

resource "yandex_alb_virtual_host" "neto_vhost" {
  name           = "neto-vhost"
  http_router_id = yandex_alb_http_router.neto_http_router.id

  route {
    name = "default-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.neto_alb_bg.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "neto_alb" {
  name        = "neto-alb"
  description = "Application Load Balancer для сайта"
  network_id  = yandex_vpc_network.neto_vpc.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.neto_public_subnet.id
    }
  }

  listener {
    name = "neto-listener-http"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.neto_http_router.id
      }
    }
  }

  security_group_ids = [yandex_vpc_security_group.neto_alb_sg.id]
}