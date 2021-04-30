output "vpc_id" {
  description = "Unique identifier of the newly created VPC network."
  value = module.network.vpc_id
}

output "vpc_name" {
  description = "Fully qualified name of the newly created VPC network."
  value = module.network.vpc_name
}

output "web_subnet_ids" {
  description = "Unique identifiers of all web subnets"
  value = module.network.web_subnet_ids
}

output "app_subnet_ids" {
  description = "Unique identifiers of all application subnets"
  value = module.network.app_subnet_ids
}

output "data_subnet_ids" {
  description = "Unique identifiers of all datastore subnets"
  value = module.network.app_subnet_ids
}

output "web_instance_id" {
  description = "Unique identifier of the web server instance"
  value = module.web_server.ec2_instance_id
}

output "web_instance_name" {
  description = "Name of the web server instance"
  value = module.web_server.ec2_instance_name
}

output "app_instance_id" {
  description = "Unique identifier of the application server instance"
  value = module.app_server.ec2_instance_id
}

output "app_instance_name" {
  description = "Name of the application server instance"
  value = module.app_server.ec2_instance_name
}

/*
output "postgres_id" {
  description = "unique identifier of the postgres service"
  value = aws_db_instance.postgres.id
}

output "postgres_host" {
  description = "hostname of the postgres service"
  value = aws_db_instance.postgres.address
}

output "postgres_port" {
  description = "port number of the postgres service"
  value = aws_db_instance.postgres.port
}
*/