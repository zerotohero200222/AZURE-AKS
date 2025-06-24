variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.aks_cluster_name))
    error_message = "AKS cluster name must contain only alphanumeric characters and hyphens."
  }
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
  validation {
    condition     = var.node_count >= 1 && var.node_count <= 100
    error_message = "Node count must be between 1 and 100."
  }
}

variable "node_size" {
  description = "Size of each AKS node"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
