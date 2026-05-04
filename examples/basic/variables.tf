variable "location" {
  description = "Azure region for the example deployment."
  type        = string
  default     = "westeurope"
}

variable "env" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "app" {
  description = "Application name used in resource naming."
  type        = string
  default     = "hello-aca"
}

variable "image" {
  description = "Container image deployed in ACA."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
