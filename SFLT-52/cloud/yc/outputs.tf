output "vm_ips" {
  description = "IP ВМ"
  value       = [for vm in yandex_compute_instance.vm : vm.network_interface[0].ip_address]
}

output "nlb_ip" {
  description = "IP балансировщика"
  value       = yandex_lb_network_load_balancer.nlb.listener[0].external_address_spec[0].address
}
