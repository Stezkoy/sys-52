output "vm_ips" {
  description = "IP ВМ"
  value       = [for vm in yandex_compute_instance.vm : vm.network_interface[0].ip_address]
}

output "nlb_ip" {
  description = "IP балансировщика"
  value = one(
    [for listener in yandex_lb_network_load_balancer.nlb.listener :
      one(
        [for addr in listener.external_address_spec : addr.address]
      )
      if listener.name == "http-listener"
    ]
  )
}


