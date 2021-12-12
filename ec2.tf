
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sg-k8s"
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

  name = local.name
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.small"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  placement_group             = aws_placement_group.web.id
  associate_public_ip_address = true
  key_name = "comics"

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64 = base64encode(local.user_data)

  cpu_core_count       = 2 # default 4
  cpu_threads_per_core = 1 # default 2

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  enable_volume_tags = false
  # root_block_device = [
  #   {
  #     encrypted   = true
  #     volume_type = "gp3"
  #     throughput  = 200
  #     volume_size = 50
  #     tags = {
  #       Name = "my-root-block"
  #     }
  #   },
  # ]

  # ebs_block_device = [
  #   {
  #     device_name = "/dev/sdf"
  #     volume_type = "gp3"
  #     volume_size = 5
  #     throughput  = 200
  #     encrypted   = true
  #     kms_key_id  = aws_kms_key.this.arn
  #   }
  # ]

  tags = local.tags
}
