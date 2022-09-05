resource "azurerm_resource_group" "rg-ad" {
  name     = "rg-ad"
  location = var.regiao
  tags = {
    environment = "dev"
    source      = "Terraform"
  }

}