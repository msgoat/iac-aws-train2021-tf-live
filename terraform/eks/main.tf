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

# create the VPC to host all EC2 instances and RDS Postgres instances
module "cluster" {
  source = "../../../iac-aws-containers-tf-module/modules/eks/cluster-all-in-one"
  region_name = var.region_name
  network_cidr = var.network_cidr
  inbound_traffic_cidrs = var.inbound_traffic_cidrs
  aws_profile_name = "theism-eu-west-1-cloudtrain"
  common_tags = local.main_common_tags
  kube_config_file_dir = "./target/kube"
  kubernetes_cluster_name = "train2021"
  solution_name = "iac2021"
  solution_stage = "dev"
  solution_fqn = "iac2021-dev"
}
