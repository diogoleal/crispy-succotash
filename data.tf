data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}


locals {
  name         = "k8s"
  name_rancher = "rancher"
  region       = "us-east-1"

  user_data = <<-EOT
  #!/bin/bash

  echo "Hello Terraform!"
  EOT

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "comics"
  }
}

resource "aws_kms_key" "this" {
}
resource "aws_network_interface" "this" {
  subnet_id = element(module.vpc.private_subnets, 0)
}

resource "aws_placement_group" "web" {
  name     = local.name
  strategy = "cluster"
}