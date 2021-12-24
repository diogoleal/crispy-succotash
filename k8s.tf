
module "k8s_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "k8s"
  description = "Security Group k8s"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

module "k8s_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = local.name_k8s
  ami                         = "ami-02c9ebf50ae56530e"
  count                       = var.k8s_count
  instance_type               = var.instance_type_k8s
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.k8s_security_group.security_group_id]
  key_name                    = var.key_name
  user_data_base64            = base64encode(local.user_data)
  associate_public_ip_address = true
  tags                        = local.tags
}

resource "aws_volume_attachment" "this" {
  count       = var.k8s_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = module.k8s_instance[count.index].id
}

resource "aws_ebs_volume" "this" {
  availability_zone = element(module.vpc.azs, 0)
  count             = var.k8s_count
  size              = 20
  tags              = local.tags
}
