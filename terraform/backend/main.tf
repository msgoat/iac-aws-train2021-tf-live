provider "aws" {
  region  = "eu-west-1"
}


# Local values used in this module
locals {
  solution_name = "CloudTrain"
  solution_stage = "DEV"
  solution_fqn = "${lower(local.solution_name)}-${lower(local.solution_stage)}"
  main_common_tags = {
    Organization = "msg systems"
    Department = "Automotive Academy"
    Project = local.solution_name
    Stage = local.solution_stage
  }
}

module backend {
  source = "github.com/msgoat/iac-aws-backend-tf-module.git"
  common_tags = local.main_common_tags
  region_name = "eu-west-1"
  solution_fqn = local.solution_fqn
  solution_name = local.solution_name
  solution_stage = local.solution_stage
  backend_name = "train2021"
}