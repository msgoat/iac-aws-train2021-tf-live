terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "s3-eu-west-1-cloudtrain-dev-train2021"
    dynamodb_table = "dyn-eu-west-1-cloudtrain-dev-train2021"
    key            = "vpc_ec2_rds/terraform.tfstate"
  }
}