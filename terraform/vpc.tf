# This file will generate the necessary prerequisites for creating services that are reachable to the outside world.

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
# DATA LOOKUP EXAMPLE
data "aws_availability_zones" "available" {}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# MODULE EXAMPLE
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14"

  name = "terraform-example"
  cidr = "10.1.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_nat_gateway = true
}
