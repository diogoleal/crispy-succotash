output "instance_ip_addr" {
  value = module.vpc.vpc_id
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "rancher_security_group_id" {
  value = module.rancher_security_group.security_group_id
}

output "rancher_instance_arn" {
  value = module.rancher_instance.arn
}

output "rancher_instance_private_ip" {
  value = module.rancher_instance.private_ip
}

output "rancher_instance_private_dns" {
  value = module.rancher_instance.private_dns
}
