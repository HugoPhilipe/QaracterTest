variable "resource_group" {
  description = "Resource Group"
  type        = string
}

variable "acr_name" {
  type        = string
  description = "Nome do Azure Container Registry"
}

variable "image_name" {
  type        = string
  description = "Nome da imagem Docker"
}

variable "subscription_id" {
  type        = string
  description = "ID da assinatura da Azure"
}

variable "client_id" {
  type        = string
  description = "Client ID do Service Principal"
}

variable "client_secret" {
  type        = string
  description = "Client Secret do Service Principal"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID da Azure"
}


