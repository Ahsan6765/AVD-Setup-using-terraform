variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev)"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}
