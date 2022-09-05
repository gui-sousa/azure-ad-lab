resource "azurerm_windows_virtual_machine" "instacia-ad" {
  name                = var.hostname
  resource_group_name = azurerm_resource_group.rg-ad.name
  location            = azurerm_resource_group.rg-ad.location
  size                = var.tipo-vm
  admin_username      = var.usuario-adm
  admin_password      = var.senha-adm

  network_interface_ids = [
    azurerm_network_interface.nic-ad.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.versao-windows
    version   = "latest"
  }

}