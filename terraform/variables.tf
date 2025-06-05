variable "resource_group" {
  default = "rg-spring-hello"
}
variable "location" {
  default = "eastus"
}
variable "container_app_name" {
  default = "spring-hello-app"
}
variable "container_image" {
  description = "Docker image to deploy"
}
