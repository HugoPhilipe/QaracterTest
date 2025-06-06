provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "springhelloregistry"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "env" {
  name                = "spring-hello-env"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_container_app" "app" {
  name                         = "spring-hello-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group
  revision_mode                = "Single"  # ou "Multiple" se você quiser controle de revisões

  template {
    container {
      name   = "spring-hello"
      image  = "${var.acr_name}.azurecr.io/${var.image_name}:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

