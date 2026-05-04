variable "cloud_id" {
  description = "Идентификатор облака Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Идентификатор каталога Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "ssh_key_path" {
  description = "Путь к публичному SSH-ключу для пользователя stez"
  type        = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_path" {
  description = "Путь к приватному SSH-ключу для Ansible"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "default_zone" {
  description = "Зона по умолчанию для публичных ресурсов"
  type        = string
  default     = "ru-central1-a"
}

variable "zones" {
  description = "Зоны доступности для отказоустойчивости"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b"]
}

variable "vpc_cidr" {
  description = "CIDR всей VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR публичной подсети"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_a_subnet_cidr" {
  description = "CIDR приватной подсети в зоне A"
  type        = string
  default     = "10.10.101.0/24"
}

variable "private_b_subnet_cidr" {
  description = "CIDR приватной подсети в зоне B"
  type        = string
  default     = "10.10.102.0/24"
}

variable "preemptible" {
  description = "Использовать прерываемые ВМ (true — да, false — на постоянку)"
  type        = bool
  default     = true
}