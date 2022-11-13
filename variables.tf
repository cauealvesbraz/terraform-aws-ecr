variable "name" {
  type        = string
  default     = ""
  description = "(Required) Name of the repository"
}

variable "encryption" {
  type = object({
    type    = string
    kms_key = optional(string)
  })

  default = {
    type    = "AES256"
    kms_key = ""
  }

  description = "(Optional) Encryption configuration of the repository. Default AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption.type)
    error_message = "The encryption type must be one of: AES256 or KMS."
  }
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to IMMUTABLE."

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image tag mutability must be one of: MUTABLE or IMMUTABLE."
  }
}

variable "force_delete" {
  type        = bool
  default     = false
  description = "(Optional) If true, will delete the repository even if it contains images. Defaults to false"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). Defauls to true"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to resources"
}

variable "registry_scanning_configuration" {
  type = object({
    scan_type = string
    rules = optional(list(object({
      scan_frequency = string
      repository_filter = object({
        filter = string
      })
    })))
  })

  default = {
    scan_type = "BASIC"
    rules = []
  }

  description = "The registry scanning configuration"

  validation {
    condition     = contains(["ENHANCED", "BASIC"], var.registry_scanning_configuration.scan_type)
    error_message = "The scan type must be one of: ENHANCED or BASIC."
  }

  validation {
    condition = alltrue([
      for rule in var.registry_scanning_configuration.rules : contains(
        ["SCAN_ON_PUSH", "CONTINUOUS_SCAN", "MANUAL"],
        rule.scan_frequency
      )
    ])

    error_message = "The scan frequency must be one of: SCAN_ON_PUSH, CONTINUOUS_SCAN or MANUAL."
  }
}
