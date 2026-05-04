output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID of the resource group."
  value       = azurerm_resource_group.rg.id
}

output "container_app_environment_id" {
  description = "ID of the Azure Container Apps environment."
  value       = azurerm_container_app_environment.cae.id
}

output "container_app_id" {
  description = "ID of the container app."
  value       = azurerm_container_app.ca.id
}

output "container_app_fqdn" {
  description = "FQDN of the latest container app revision."
  value       = azurerm_container_app.ca.latest_revision_fqdn
}

output "container_app_url" {
  description = "HTTPS URL of the container app."
  value       = "https://${azurerm_container_app.ca.latest_revision_fqdn}"
}
