module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.31.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.31.1.0/24", "10.31.2.0/24", "10.31.3.0/24"]
  public_subnets  = ["10.31.101.0/24", "10.31.102.0/24", "10.31.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
    "karpenter.sh/discovery"              = local.name
  }

  tags = local.tags
}
