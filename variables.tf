variable "doppler_token" {
  description = "Doppler token to authenticate"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "The name of the Doppler project"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9_-]{1,80}$", var.project_name))
    error_message = "The project name can only contain lowercase letters, numbers, hyphens, and underscores, and must not be longer than 80 characters."
  }
}

variable "project_description" {
  description = "The description of the Doppler project"
  type        = string
  default     = ""
}

variable "environment_name" {
  description = "The name of the Doppler environment"
  type        = string
}

variable "environment_slug" {
  description = "The slug of the Doppler environment"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9_-]{1,15}$", var.environment_slug))
    error_message = "The environment slug can only contain lowercase letters, numbers, hyphens, and underscores, and must not be longer than 15 characters."
  }
}

# variable "enable_custom_branch_config" {
#   description = "If enabled, It will create branch config"
#   type        = bool
#   default     = false
# }

variable "config_name" {
  description = "The description of the Doppler project"
  type        = string
  default     = ""
}


variable "secrets" {
  description = "The Doppler secrets to create (key/value pair)"
  type        = map(string)
}

variable "service_token_access" {
  description = "The access level (read or read/write). Defaults to 'read'"
  type        = string
  default     = "read"
  validation {
    condition     = contains(["read", "read/write"], var.service_token_access)
    error_message = "Error: Token access options can be read or read/write only."
  }
}

variable "service_token_name" {
  description = "Service token name"
  type        = string
  default     = ""
}

variable "is_service_token_required" {
  description = "If enabled, create a Service Token"
  type        = bool
  default     = false
}
