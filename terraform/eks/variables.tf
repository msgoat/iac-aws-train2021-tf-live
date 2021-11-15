variable "region_name" {
  description = "The AWS region to deploy into (e.g. eu-central-1)."
  type = string
  default = "eu-west-1"
}

variable "organization_name" {
  description = "The name of the organization that owns all AWS resources."
  type = string
  default = "msg systems"
}

variable "department_name" {
  description = "The name of the department that owns all AWS resources."
  type = string
  default = "Automotive Academy"
}

variable "project_name" {
  description = "The name of the project that owns all AWS resources."
  type = string
  default = "CloudTrain"
}

variable "stage" {
  description = "The name of the current environment stage."
  type = string
  default = "dev"
}

variable "network_name" {
  description = "The name suffix of the VPC."
  type = string
  default = "train2021"
}

variable "network_cidr" {
  description = "The CIDR range of the VPC."
  type = string
  default = "10.17.0.0/16"
}

variable "inbound_traffic_cidrs" {
  description = "The IP ranges in CIDR notation allowed to access any public resource within the network."
  default = [
    "0.0.0.0/0"]
  type = list(string)
}

variable "nat_strategy" {
  description = "NAT strategy to be applied to VPC. Possible values are: NAT_GATEWAY (default) or NAT_INSTANCE"
  type = string
  default = "NAT_GATEWAY"
}

variable "nat_instance_type" {
  description = "EC2 instance type to be used for the NAT instances; will only be used if nat_strategy == NAT_GATEWAY"
  type = string
  default = "t3.micro"
}

variable "bastion_key_name" {
  description = "Name of SSH key pair name to used for the bastion instances"
  type = string
  default = "key-eu-west-1-train2021-bastion"
}


