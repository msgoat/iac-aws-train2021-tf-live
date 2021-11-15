output terraform_backend_file {
  description = "Content of a Terraform backend file referring to this backend"
  value = module.backend.terraform_backend_file
}