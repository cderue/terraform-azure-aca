
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    app         = var.app
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.stack}"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${local.stack}"
  location            = azurerm_resource_group.my_first_app.location
  resource_group_name = azurerm_resource_group.my_first_app.name

  tags = local.default_tags
}

resource "azurerm_container_app_environment" "cae" {
  name                      = "cae-${local.stack}"
  location                   = azurerm_resource_group.my_first_app.location
  resource_group_name        = azurerm_resource_group.my_first_app.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.my_first_app.id

  tags = local.default_tags
}

resource "azurerm_container_app" "ca" {
  name                         = "ca-${local.stack}"

  container_app_environment_id = azurerm_container_app_environment.my_first_app.id
  resource_group_name          = azurerm_resource_group.my_first_app.name
  revision_mode                = "Single"

  registry {
    server               = "docker.io"
    username             = "dockerIOUserName"
    password_secret_name = "docker-io-pass"
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage = 100
    }
  }

  template {
    container {
      name   = "ca-${local.stack}"
      image  = var.image
      cpu    = 0.25
      memory = "0.5Gi"
  }

  tags = local.default_tags

}

