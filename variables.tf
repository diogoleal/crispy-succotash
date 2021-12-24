variable "dns_name" {
  type    = string
  default = "comics.internal"
}

variable "k8s_count" {
  type    = string
  default = 3
}

variable "instance_type_k8s" {
  type        = string
  default     = "t3a.medium"
}

variable "key_name" {
  type        = string
  default     = "comics"
}
