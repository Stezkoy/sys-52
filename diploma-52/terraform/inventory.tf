resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    bastion_ip             = yandex_compute_instance.neto_bastion.network_interface[0].nat_ip_address
    ssh_private_key_path   = var.ssh_private_key_path
  })
  filename = "${path.module}/ansible/inventory.ini"
}