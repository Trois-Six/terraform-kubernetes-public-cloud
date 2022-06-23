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
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    instance_type                         = var.nodes_type
    attach_cluster_primary_security_group = true
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
