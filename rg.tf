resource "azurerm_resource_group" "rg-ad" {
  name     = "rg-ad"
  location = "eastus"
  tags = {
    environment = "dev"
    source      = "Terraform"
  }

}