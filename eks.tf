module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = local.name
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  node_security_group_additional_rules = {
    ingress_karpenter_webhook_tcp = {
      description                   = "Control plane invoke Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    karpenter = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      iam_role_additional_policies = [
        "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })
}
