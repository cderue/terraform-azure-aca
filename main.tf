provider "azurerm" {
  features {}
}

provider "random" {}

locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = "J.Son"
    app         = var.app
  }
}

resource "azurerm_resource_group" "my_first_app" {
  name     = "rg-${local.stack}"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "my_first_app" {
  name                = "log-${local.stack}"
  location            = azurerm_resource_group.my_first_app.location
  resource_group_name = azurerm_resource_group.my_first_app.name

  tags = local.default_tags
}

resource "azurerm_container_app_environment" "my_first_app" {
  name                      = "cae-${local.stack}"
  location                   = azurerm_resource_group.my_first_app.location
  resource_group_name        = azurerm_resource_group.my_first_app.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.my_first_app.id

  tags = local.default_tags
}

resource "azurerm_container_app" "my_first_app" {
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
      image  = "test/myapp"
      cpu    = 0.25
      memory = "0.5Gi"
  }
  
  secret { 
    name  = "docker-io-pass" 
    value = "MyDockerIOPass" 
  }

  tags = local.default_tags

}

