variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_group_name" {
  default = "dash-app-rg"
}
variable "location" {
  default = "East US"
}
variable "app_service_plan_name" {
  default = "dash-app-plan"
}
variable "web_app_name" {
  default = "dash-docker-app"
}
variable "docker_image" {
  description = "Image name (without ACR prefix)"
}