terraform{
  required_version =">= 0.12"

  backend "azurerm"{
    storage_account_name = "terraformstorageae1d6e97"
    container_name = "terraform"
    key = "terraform.tfstate"
    access_key = "kmzhfJDs+MZKoi1vJAXD/a4TEDpLzGz5LUQ1yc5AhqyE+1zbo+RQvhUj/Dc6hyYv+j96H2RCSTUt0NFULgfUyA=="
  }
}

provider "azurerm" {
    version = "=1.44.0"
}

resource "azurerm_resource_group" "App_PROD" {
  name     = "${var.name_prefix}-PROD-App-RG"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "PROD" {
  name                = "${var.name_prefix}-PROD-AppServicePlan"
  location            = "${azurerm_resource_group.App_PROD.location}"
  resource_group_name = "${azurerm_resource_group.App_PROD.name}"
  tags     = "${var.tags}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "PROD" {
  name                = "${var.name_prefix}prodapp01"
  location            = "${azurerm_resource_group.App_PROD.location}"
  resource_group_name = "${azurerm_resource_group.App_PROD.name}"
  app_service_plan_id = "${azurerm_app_service_plan.PROD.id}"
  

  site_config {
    php_version = "7.2"
    default_documents = ["index.html","hostingstart.html","index.php"]
    scm_type = "None"
  }

}
