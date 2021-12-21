locals {
  zone_name = sort(keys(module.zones.route53_zone_zone_id))[0]
  #  zone_id = module.zones.route53_zone_zone_id["app.comics.internal"]
}

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "comics.internal" = {
      comment = "comics.internal (production)"
      tags = {
        Name = "comics.internal"
      }
    }

    "app.comics.internal" = {
      comment = "app.comics.internal"
      tags = {
        Name = "app.comics.internal"
      }
    }

    "private-vpc.comics.internal" = {
      domain_name = "comics.internal"
      comment     = "private-vpc.comics.internal"
      vpc = [
        {
          vpc_id = module.vpc.vpc_id
        },
      ]
      tags = local.tags
    }
  }

  tags = local.tags
}

module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 2.4.0"
  zone_name = local.zone_name
  #  zone_id = local.zone_id

  records = [
    {
      name = "rancher.comics.internal"
      type = "A"
      ttl  = 3600
      records = [
        "1.1.1.1",
      ]
    }
  ]

  depends_on = [module.zones]
}
