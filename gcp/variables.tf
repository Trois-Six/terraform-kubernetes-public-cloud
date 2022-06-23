variable "project_id" {
  description = "The GCP project id."
  type        = string
}

variable "region" {
  description = "The GCP region in which to deploy."
  type        = string
}

variable "prefix" {
  description = "Prefix used for some resources."
  type        = string
}

variable "subnet_prefix" {
  description = "Subnet prefix (in CIDR format)."
  type        = string
}

variable "nodes_type" {
  description = "Types of machines to host GKE."
  default     = "n1-standard-1"
}

variable "num_nodes" {
  description = "The number of gke nodes."
  default     = 1
}
