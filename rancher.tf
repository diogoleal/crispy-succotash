
module "rancher_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "rancher"
  description = "Security Group Rancher"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

module "rancher_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                        = local.name_rancher
  ami                         = "ami-0d70a7bf361d3f60a"
  instance_type               = "t3a.medium"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.rancher_security_group.security_group_id]
  key_name                    = "comics"
  user_data_base64            = base64encode(local.user_data)
  associate_public_ip_address = true
  tags                        = local.tags
}

resource "aws_volume_attachment" "isto" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.isto.id
  instance_id = module.rancher_instance.id
}

resource "aws_ebs_volume" "isto" {
  availability_zone = element(module.vpc.azs, 0)
  size              = 20
  tags              = local.tags
}

resource "aws_eip" "rancher" {
  instance = module.rancher_instance.id
  vpc      = true
}
