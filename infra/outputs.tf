output "web_app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}