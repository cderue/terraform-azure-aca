module "aca" {
  source = "../.."

  location = var.location
  env      = var.env
  app      = var.app
  image    = var.image

  ingress_external_enabled           = true
  ingress_allow_insecure_connections = true
  ingress_target_port                = 8080

  min_replicas = 0
  max_replicas = 2

  additional_tags = {
    example = "http-ingress"
    tier    = "dev"
  }
}

output "container_app_url" {
  value = module.aca.container_app_url
}
