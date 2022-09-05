resource "azurerm_windows_virtual_machine" "instacia-ad" {
  name                = "instancia-ad"
  resource_group_name = azurerm_resource_group.rg-ad.name
  location            = azurerm_resource_group.rg-ad.location
  size                = "Standard_F2"
  admin_username      = "gincobiloba"
  admin_password      = "Ginco@31243536@"

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
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}