module "aca" {
  source = "../.."

  location = var.location
  env      = var.env
  app      = var.app
  image    = var.image

  ingress_external_enabled           = false
  ingress_allow_insecure_connections = false
  ingress_target_port                = 8080

  min_replicas = 1
  max_replicas = 2

  additional_tags = {
    example = "private-ingress"
    tier    = "internal"
  }
}

output "container_app_fqdn" {
  value = module.aca.container_app_fqdn
}
