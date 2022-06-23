variable "aws_region" {
  description = "The AWS region in which to deploy."
  type        = string
}

variable "aws_azs" {
  description = "The AWS availability zones in which to deploy."
  type        = list(any)
}

variable "prefix" {
  description = "Prefix used for some resources."
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC address space."
  type        = string
}

variable "public_subnet_prefix" {
  description = "Public subnet prefix in VPC (in CIDR format)."
  type        = string
}

variable "private_subnet_prefix" {
  description = "Private subnet prefix in VPC (in CIDR format)."
  type        = string
}

variable "nodes_type" {
  description = "Type of node instance used to host K8S."
  default     = "t3a.medium"
}

variable "num_nodes" {
  description = "Number of K8S nodes."
  default     = 3
}
