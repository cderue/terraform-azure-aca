variable "location" {
  description = "Azure region for the deployment."
  type        = string
  default     = "westeurope"
}

variable "env" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

variable "app" {
  description = "Application name."
  type        = string
  default     = "orders-api"
}

variable "image" {
  description = "Container image."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
