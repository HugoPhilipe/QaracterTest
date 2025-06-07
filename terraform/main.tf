provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
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

resource "azurerm_user_assigned_identity" "app" {
  name                = "spring-hello-app-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_user_assigned_identity.app.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group
  revision_mode                = "Single"  # ou "Multiple" se você quiser controle de revisões

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.app.id
  }

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
}

