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