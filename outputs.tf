output "azurerm_container_app_url" {
  value = azurerm_container_app.ca.latest_revision_fqdn
}
