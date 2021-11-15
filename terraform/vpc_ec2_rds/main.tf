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
  solution_fqn = "${lower(var.project_name)}-${lower(var.stage)}"
}

# create the VPC to host all EC2 instances and RDS Postgres instances
module "network" {
  # source = "../../../iac-aws-networks-tf-module"
  source = "github.com/msgoat/iac-aws-networks-tf-module.git"
  region_name = var.region_name
  solution_name = var.project_name
  solution_stage = var.stage
  solution_fqn = local.solution_fqn
  common_tags = local.main_common_tags
  network_name = var.network_name
  network_cidr = var.network_cidr
  inbound_traffic_cidrs = var.inbound_traffic_cidrs
  bastion_key_name = var.bastion_key_name
}

# to keep things simple retrieve the latest AMI version used for all EC2 instances
data "aws_ami" "amazon_linux2" {
  owners = [
    "137112412989"]
  #  executable_users = ["self"]
  most_recent = "true"
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*"]
  }
  filter {
    name = "root-device-type"
    values = [
      "ebs"]
  }
  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
}

# create a single web server in first availability zone
module "web_server" {
  # source = "../../../iac-aws-virtual-machines-tf-module"
  source = "github.com/msgoat/iac-aws-virtual-machines-tf-module.git"
  region_name = var.region_name
  solution_name = var.project_name
  solution_stage = var.stage
  solution_fqn = local.solution_fqn
  common_tags = local.main_common_tags
  vpc_id = module.network.vpc_id
  subnet_id = module.network.web_subnet_ids[0]
  ami_id = data.aws_ami.amazon_linux2.id
  instance_name = "train2021-web"
  instance_type = "t3.micro"
  instance_key_name = "key-eu-central-1-train2021-web"
  root_volume_size = "32"
  data_volume_size = "50"
}

# create a single application server in first availability zone
module "app_server" {
  # source = "../../../iac-aws-virtual-machines-tf-module"
  source = "github.com/msgoat/iac-aws-virtual-machines-tf-module.git"
  region_name = var.region_name
  solution_name = var.project_name
  solution_stage = var.stage
  solution_fqn = local.solution_fqn
  common_tags = local.main_common_tags
  vpc_id = module.network.vpc_id
  subnet_id = module.network.app_subnet_ids[0]
  ami_id = data.aws_ami.amazon_linux2.id
  instance_name = "train2021-app"
  instance_type = "t3.micro"
  instance_key_name = "key-eu-central-1-train2021-app"
  root_volume_size = "32"
  data_volume_size = "50"
}

module "postgres"  {
  # source = "../../../iac-aws-databases-tf-module/modules/postgresql"
  source = "github.com/msgoat/iac-aws-databases-tf-module.git//modules/postgresql"
  region_name = var.region_name
  solution_name = var.project_name
  solution_stage = var.stage
  solution_fqn = local.solution_fqn
  common_tags = local.main_common_tags
  db_instance_name = "train2021"
  db_database_name = "train2021"
  vpc_id = module.network.vpc_id
  db_subnet_ids = module.network.data_subnet_ids
}
