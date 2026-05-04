locals {
  default_cloud_config = <<-EOF
    #cloud-config
    users:
      - name: stez
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${file(var.ssh_key_path)}
  EOF
}