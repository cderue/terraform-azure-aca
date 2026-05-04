locals {
  location_normalized = lower(replace(var.location, " ", ""))
  stack               = "${var.env}-${local.location_normalized}-${var.resource_suffix}"

  default_tags = merge(
    {
      environment = var.env
      app         = var.app
    },
    var.additional_tags,
    var.waypoint_application != "" ? { waypoint_application = var.waypoint_application } : {}
  )
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
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_in_days

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

  ingress {
    allow_insecure_connections = var.ingress_allow_insecure_connections
    external_enabled           = var.ingress_external_enabled
    target_port                = var.ingress_target_port

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "${var.app}-${local.stack}"
      image  = var.image
      cpu    = var.container_cpu
      memory = var.container_memory
    }
  }

  tags = local.default_tags
}

