module "aca" {
  source = "../.."

  location = var.location
  env      = var.env
  app      = var.app
  image    = var.image

  min_replicas = 0
  max_replicas = 1

  additional_tags = {
    example = "basic"
  }
}

output "container_app_url" {
  value = module.aca.container_app_url
}
