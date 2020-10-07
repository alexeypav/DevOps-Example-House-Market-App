resource "azurerm_resource_group" "SQL_PROD" {
  name     = "${var.name_prefix}-Prod-SQL-RG"
  location = "${var.location}"
}

resource "azurerm_sql_server" "PROD" {
  name                         = "${var.name_prefix}sqlprod"
  version                      = "12.0"
  resource_group_name          = "${azurerm_resource_group.SQL_PROD.name}"
  location                     = "${azurerm_resource_group.SQL_PROD.location}"
  administrator_login          = "localadmin"
  administrator_login_password = "Pass20192019"
}

resource "azurerm_sql_firewall_rule" "allowIP" {
  name     = "CompanyAllow"
  resource_group_name = "${azurerm_resource_group.SQL_PROD.name}"
  start_ip_address = "$(myIP)"
  end_ip_address   = "$(myIP)"

  server_name = "${azurerm_sql_server.PROD.name}"
  
}


resource "azurerm_sql_firewall_rule" "allowIP2" {
  name     = "CompanyAllow"
  resource_group_name = "${azurerm_resource_group.SQL_PROD.name}"
  start_ip_address = "$(myIP2)"
  end_ip_address   = "$(myIP2)"

  server_name = "${azurerm_sql_server.PROD.name}"
  
}

resource "azurerm_sql_firewall_rule" "allowIP3" {
  name     = "CompanyAllowTF"
  resource_group_name = "${azurerm_resource_group.SQL_PROD.name}"
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  server_name = "${azurerm_sql_server.PROD.name}"
  
}


resource "azurerm_sql_database" "main" {
  name                = "ProdDB01"
  resource_group_name = "${azurerm_resource_group.SQL_PROD.name}"
  location            = "${azurerm_resource_group.SQL_PROD.location}"
  server_name         = "${azurerm_sql_server.PROD.name}"
  edition             = "Standard"
  requested_service_objective_name = "S1"

  import {
    storage_uri = "https://apptemplatestorage.blob.core.windows.net/databasetemplate/Database-Template.bacpac"
    storage_key = "$(storageAccountKey)"
    storage_key_type = "StorageAccessKey"
    administrator_login = "${azurerm_sql_server.PROD.administrator_login}"
    administrator_login_password= "${azurerm_sql_server.PROD.administrator_login_password}"
    authentication_type = "SQL"

  }

  tags = {
    environment = "production"
  }
}