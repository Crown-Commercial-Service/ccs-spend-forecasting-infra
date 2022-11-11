output "storage_container_names" {
  value = tolist(azurerm_storage_container.container[*].name)
}

output "storage_account_id" {
  value = azurerm_storage_account.account.id
}
