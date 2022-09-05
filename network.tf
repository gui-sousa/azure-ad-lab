resource "azurerm_virtual_network" "vn-ad" {
  name                = "vn-ad"
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.rg-ad.location
  resource_group_name = azurerm_resource_group.rg-ad.name
}

resource "azurerm_subnet" "subnet-ad" {
  name                 = "subnet-ad"
  resource_group_name  = azurerm_resource_group.rg-ad.name
  virtual_network_name = azurerm_virtual_network.vn-ad.name
  address_prefixes     = ["10.1.0.0/26"]
}

resource "azurerm_network_interface" "nic-ad" {
  name                = "nic-ad"
  location            = azurerm_resource_group.rg-ad.location
  resource_group_name = azurerm_resource_group.rg-ad.name

  ip_configuration {
    name                          = "ip-ad"
    subnet_id                     = azurerm_subnet.subnet-ad.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub-ip-ad.id
  }

  depends_on = [
    azurerm_virtual_network.vn-ad,
    azurerm_public_ip.pub-ip-ad
  ]

}

resource "azurerm_public_ip" "pub-ip-ad" {
  name                    = "pub-ip-ad"
  location                = azurerm_resource_group.rg-ad.location
  resource_group_name     = azurerm_resource_group.rg-ad.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_security_group" "nsg-ad" {
  name                = "nsg-ad"
  location            = azurerm_resource_group.rg-ad.location
  resource_group_name = azurerm_resource_group.rg-ad.name


  security_rule {
    name                       = "HTTPS"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "winrm"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "winrm-out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-association-ad" {
    subnet_id = azurerm_subnet.subnet-ad.id
    network_security_group_id = azurerm_network_security_group.nsg-ad.id

    depends_on = [
      azurerm_subnet.subnet-ad, azurerm_network_security_group.nsg-ad
    ]

  
}