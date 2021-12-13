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
      # in case than private and public zones with the same domain name
      domain_name = "comics.internal"
      comment     = "private-vpc.comics.internal"
      vpc = [
        {
          vpc_id = module.vpc.vpc_id
        },
      ]
      tags = local.tags
      # tags = {
      #   Name = "private-vpc.terraform-aws-modules-example.com"
      # }
    }
  }

  tags = local.tags

}

module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 2.0"
  zone_name = local.zone_name
  #  zone_id = local.zone_id

  records = [
    {
      name = ""
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    },
    {
      name           = "test"
      type           = "CNAME"
      ttl            = 5
      records        = ["test.example.com."]
      set_identifier = "test-primary"
      weighted_routing_policy = {
        weight = 90
      }
    },
    {
      name           = "test"
      type           = "CNAME"
      ttl            = 5
      records        = ["test2.example.com."]
      set_identifier = "test-secondary"
      weighted_routing_policy = {
        weight = 10
      }
    }
  ]

  depends_on = [module.zones]
}



