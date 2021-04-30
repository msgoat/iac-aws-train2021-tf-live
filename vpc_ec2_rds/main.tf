# ----------------------------------------------------------------------------
# main.tf
# ----------------------------------------------------------------------------
# Main entrypoint of this Terraform module.
# ----------------------------------------------------------------------------

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
module "network" {
  source = "../../iac-aws-networks-tf-module/"
  region_name = var.region_name
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
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
  source = "../../iac-aws-virtual-machines-tf-module/"
  region_name = var.region_name
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
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
  source = "../../iac-aws-virtual-machines-tf-module/"
  region_name = var.region_name
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
  vpc_id = module.network.vpc_id
  subnet_id = module.network.web_subnet_ids[0]
  ami_id = data.aws_ami.amazon_linux2.id
  instance_name = "train2021-app"
  instance_key_name = "key-eu-central-1-train2021-app"
  instance_type = "t3.micro"
  root_volume_size = "32"
  data_volume_size = "50"
}

module "postgres"  {
  source = "../../iac-aws-databases-tf-module/modules/postgresql"
  region_name = var.region_name
  common_tags = local.main_common_tags
  db_instance_name = "train2021"
  db_database_name = "train2021"
  solution_name = "train2021"
  solution_stage = "dev"
  solution_fqn = "train2021-dev"
  vpc_id = module.network.vpc_id
  db_subnet_ids = module.network.data_subnet_ids
}

/*
locals {
  rds_instance_name = "cloudtrain-pg"
}

# create an AWS RDS for Postgres instance
resource "aws_db_instance" "postgres" {
  identifier = "rds-${var.region_name}-${local.rds_instance_name}"
  engine = "postgres"
  engine_version = "12.4"
  instance_class = "db.m5.large"
  storage_type = "io1"
  iops = "1000"
  allocated_storage = 100
  max_allocated_storage = 200
  name = "cloudtrain"
  username = "foo"
  password = "foobarbaz"
  db_subnet_group_name = aws_db_subnet_group.postgres.name
  skip_final_snapshot = true
  tags = merge(map(
  "Name", "rds-${var.region_name}-${local.rds_instance_name}"
  ), local.main_common_tags)
}

# create a DB subnet group for the DB instances
resource "aws_db_subnet_group" "postgres" {
  name = "dbsng-${var.region_name}-${local.rds_instance_name}"
  subnet_ids = module.reference_vpc.data_subnet_ids
  tags = merge(map(
  "Name", "dbsng-${var.region_name}-${local.rds_instance_name}"
  ), local.main_common_tags)
}
*/