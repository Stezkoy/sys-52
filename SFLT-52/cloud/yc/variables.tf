variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  type        = string
  default     = "fd883qojk2a3hruf8p7m"
}

variable "ssh_key_path" {
  type        = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "folder_id" {
  type    = string
  default = "b1gbanqj8jdui3nqj78u"
}

variable "vpc_name" {
  type        = string
  default     = "neto-vpc"
}

variable "subnet_name" {
  type        = string
  default     = "neto-subnet"
}

variable "cidr" {
  type        = string
  default     = "10.1.0.0/24"
}

variable "vm_cores" {
  type        = number
  default     = 2
}

variable "vm_memory" {
  type        = number
  default     = 2
}

variable "vm_core_fraction" {
  type    = number
  default = 20
}

variable "vm_disk_size" {
  type        = number
  default     = 10
}