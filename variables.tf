variable "waypoint_application" {
  type        = string
  default     = ""
  description = "Waypoint application name."
}

variable "location" {
  description = "Azure infrastructure region"
  type    = string
}

variable "app" {
  description = "Application that we want to deploy"
  type    = string
}

variable "image" {
  description = "Docker image used for deployment"
  type    = string
}

variable "env" {
  description = "Application env"
  type    = string
}
