variable "flow" {
  type    = string
  default = "251025"
}

variable "cloud_id" {
  type    = string
  default = "b1gn3fvtj866hr8qi1ti"
}
variable "folder_id" {
  type    = string
  default = "b1gbanqj8jdui3nqj78u"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}
