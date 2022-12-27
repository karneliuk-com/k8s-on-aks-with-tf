variable "agent_count" {
  type    = number
  default = 1
}

variable "agent_sku" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "aks_service_principal_app_id" {
  type = string
}

variable "aks_service_principal_client_secret" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "k8s-on-aks"
}

variable "dns_prefix" {
  type    = string
  default = "k8s-on-aks"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group dedicated for AKS."
}

variable "ssh_public_key" {
  type    = string
  default = "./ssh-pub.key"
}
