variable "waypoint_application" {
  type        = string
  default     = ""
  description = "Waypoint application name."
}

variable "location" {
  description = "Azure infrastructure region"
  type        = string

  validation {
    condition     = trim(var.location) != ""
    error_message = "location must not be empty."
  }
}

variable "app" {
  description = "Application that we want to deploy"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.app))
    error_message = "app must contain 2 to 30 lowercase alphanumeric or hyphen characters."
  }
}

variable "image" {
  description = "Docker image used for deployment"
  type        = string

  validation {
    condition     = can(regex("^[[:graph:]]+$", var.image))
    error_message = "image must be a non-empty valid container image reference."
  }
}

variable "env" {
  description = "Application env"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,12}$", var.env))
    error_message = "env must contain 2 to 12 lowercase alphanumeric or hyphen characters."
  }
}

variable "resource_suffix" {
  description = "Suffix appended to generated resource names."
  type        = string
  default     = "001"

  validation {
    condition     = can(regex("^[a-z0-9-]{2,10}$", var.resource_suffix))
    error_message = "resource_suffix must contain 2 to 10 lowercase alphanumeric or hyphen characters."
  }
}

variable "additional_tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "log_analytics_sku" {
  description = "Log Analytics workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  description = "Retention period for Log Analytics data."
  type        = number
  default     = 30

  validation {
    condition     = var.log_analytics_retention_in_days >= 30 && var.log_analytics_retention_in_days <= 730
    error_message = "log_analytics_retention_in_days must be between 30 and 730."
  }
}

variable "ingress_allow_insecure_connections" {
  description = "Allow plain HTTP ingress to the container app."
  type        = bool
  default     = false
}

variable "ingress_external_enabled" {
  description = "Expose the container app publicly."
  type        = bool
  default     = true
}

variable "ingress_target_port" {
  description = "Container port exposed by ingress."
  type        = number
  default     = 80

  validation {
    condition     = var.ingress_target_port >= 1 && var.ingress_target_port <= 65535
    error_message = "ingress_target_port must be between 1 and 65535."
  }
}

variable "container_cpu" {
  description = "CPU allocated to the main container."
  type        = number
  default     = 0.25

  validation {
    condition     = var.container_cpu > 0
    error_message = "container_cpu must be greater than 0."
  }
}

variable "container_memory" {
  description = "Memory allocated to the main container (example: 0.5Gi)."
  type        = string
  default     = "0.5Gi"

  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]+)?(Gi|Mi)$", var.container_memory))
    error_message = "container_memory must use Mi or Gi suffix (example: 512Mi, 0.5Gi, 1Gi)."
  }
}

variable "min_replicas" {
  description = "Minimum number of container app replicas."
  type        = number
  default     = 0

  validation {
    condition     = var.min_replicas >= 0
    error_message = "min_replicas must be greater than or equal to 0."
  }
}

variable "max_replicas" {
  description = "Maximum number of container app replicas."
  type        = number
  default     = 3

  validation {
    condition     = var.max_replicas >= var.min_replicas
    error_message = "max_replicas must be greater than or equal to min_replicas."
  }
}
