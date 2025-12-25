terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.168.0"
    }
  }

  required_version = ">=1.8.4"
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  folder_id                = var.folder_id
  zone                     = var.zone
}