variable "location" {
  description = "Azure region for the deployment."
  type        = string
  default     = "westeurope"
}

variable "env" {
  description = "Environment name."
  type        = string
  default     = "int"
}

variable "app" {
  description = "Application name."
  type        = string
  default     = "private-api"
}

variable "image" {
  description = "Container image."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
