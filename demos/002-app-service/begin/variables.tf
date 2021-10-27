#--- variables.tf ---#

variable "namespace" {
  type        = string
  description = "The namespace to use in all resources"
}


variable "location" {
  type        = string
  description = "Azure region where the resources will be created"
  default     = "eastus"
}


variable "environment" {
  type        = string
  description = "Environment that will be included in resource names and tags"
  default     = "demo"
}