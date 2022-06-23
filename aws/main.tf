locals {
  tags = {
    env = var.prefix
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"

  cidr            = var.vpc_cidr_block
  azs             = var.aws_azs
  private_subnets = [for k, v in var.aws_azs : cidrsubnet(var.private_subnet_prefix, 7, k)]
  public_subnets  = [for k, v in var.aws_azs : cidrsubnet(var.public_subnet_prefix, 7, k)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.prefix}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.prefix}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "${var.prefix}-eks"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    instance_type = var.nodes_type
  }

  eks_managed_node_groups = {
    one = {
      min_size     = var.num_nodes
      max_size     = var.num_nodes
      desired_size = var.num_nodes
    }
  }

  tags = local.tags
}
