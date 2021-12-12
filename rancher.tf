
module "rancher_security_group" {
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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = local.name_rancher
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3a.medium"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.rancher_security_group.security_group_id]
  key_name                    = "comics"
  user_data_base64            = base64encode(local.user_data)
  associate_public_ip_address = true
  tags                        = local.tags
}
