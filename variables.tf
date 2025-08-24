variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "kube-cluster-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "kubecluster"
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ubuntu_version" {
  description = "Ubuntu version to use (22.04 or 24.04)"
  type        = string
  default     = "22.04"
  validation {
    condition     = contains(["22.04", "24.04"], var.ubuntu_version)
    error_message = "Ubuntu version must be either 22.04 or 24.04."
  }
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "development"
}
