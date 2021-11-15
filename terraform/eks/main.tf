# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------
# Main entrypoint of this Terraform module.
# ----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.region_name
}


# Local values used in this module
locals {
  main_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
}

# create an EKS cluster plus Application Load Balancer
module "cluster" {
  source = "github.com/msgoat/iac-aws-containers-tf-module/modules/eks/cluster-all-in-one"
  region_name = var.region_name
  network_cidr = var.network_cidr
  inbound_traffic_cidrs = var.inbound_traffic_cidrs
  common_tags = local.main_common_tags
  kubernetes_cluster_name = "train2021"
  solution_name = "cloudtrain"
  solution_stage = "dev"
  solution_fqn = "cloudtrain-dev"
}
