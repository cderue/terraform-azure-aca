variable "location" {
  description = "Azure infrastructure region"
  type    = string
  default = "westeurope"
}

variable "app" {
  description = "Application that we want to deploy"
  type    = string
  default = "hashitalks"
}

variable "env" {
  description = "Application env"
  type    = string
  default = "dev"
}
