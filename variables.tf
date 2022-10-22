variable "name" {
  type = string
  default = ""
  description = "(Required) Name of the repository"
}

variable "encryption" {
  type = object({
      type = string
      kms_key = optional(string)
  })

  default = {
    type = "AES256"
    kms_key = ""
  }

  description = "(Optional) Encryption configuration of the repository. Default AES256"

  validation {
    condition = contains(["AES256", "KMS"], var.encryption.type)
    error_message = "The encryption type must be AES256 or KMS."
  }
}

variable "image_tag_mutability" {
  type = string
  default = "IMMUTABLE"
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to IMMUTABLE."
}

variable "tags" {
  type = map(string)
  default = {}
  description = "A map of tags to add to resources"
}
