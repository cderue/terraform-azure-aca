locals {
  stack = "${var.env}-${var.location}-001"

  default_tags = {
    environment = var.env
    app         = var.app
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.stack}"
  location = var.location

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${local.stack}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.default_tags
}

resource "azurerm_container_app_environment" "cae" {
  name                      = "cae-${local.stack}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  tags = local.default_tags
}

resource "azurerm_container_app" "ca" {
  name                         = "${var.app}-${local.stack}"

  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_resource_group.rg.name
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
}

