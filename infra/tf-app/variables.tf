variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-app"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acr"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.3"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cst8918"
}

variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for AKS API server access"
  type        = list(string)
  default = [
    "0.0.0.0/32" # Replace with your actual IP ranges - this is a placeholder
    # Example corporate ranges:
    # "203.0.113.0/24",     # Corporate office network
    # "198.51.100.0/24",    # VPN network
    # "20.0.0.0/8"          # Azure services (if needed)
  ]
}
