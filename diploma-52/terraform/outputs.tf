output "bastion_public_ip" {
  description = "Публичный IP bastion"
  value       = yandex_compute_instance.neto_bastion.network_interface[0].nat_ip_address
}

output "alb_public_ip" {
  description = "Публичный IP Application Load Balancer"
  value       = yandex_alb_load_balancer.neto_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "zabbix_public_ip" {
  description = "Публичный IP Zabbix"
  value       = yandex_compute_instance.neto_zabbix.network_interface[0].nat_ip_address
}

output "kibana_public_ip" {
  description = "Публичный IP Kibana"
  value       = yandex_compute_instance.neto_kibana.network_interface[0].nat_ip_address
}

output "elasticsearch_private_ip" {
  description = "Приватный IP Elasticsearch"
  value       = yandex_compute_instance.neto_elasticsearch.network_interface[0].ip_address
}