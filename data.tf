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
  name_k8s     = "k8s"
  region       = "us-east-1"

  user_data = <<-EOT
  #!/bin/bash
  yum install docker -y
  /etc/init.d/docker start
  docker run -d --name rancher --restart=unless-stopped -v /opt/rancher:/var/lib/rancher  -p 80:80 -p 443:443 rancher/rancher:v2.4.3
  EOT

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "comics"
  }
}

resource "aws_kms_key" "this" {}

resource "aws_network_interface" "this" {
  subnet_id = element(module.vpc.private_subnets, 0)
}

resource "aws_placement_group" "web" {
  name     = local.name
  strategy = "cluster"
}
