module "aca" {
  source = "../.."

  location = var.location
  env      = var.env
  app      = var.app
  image    = var.image

  ingress_target_port = 8080

  container_cpu    = 0.5
  container_memory = "1Gi"

  min_replicas = 2
  max_replicas = 10

  log_analytics_retention_in_days = 60

  additional_tags = {
    example = "production-profile"
    tier    = "prod"
    owner   = "platform"
  }
}

output "container_app_url" {
  value = module.aca.container_app_url
}
