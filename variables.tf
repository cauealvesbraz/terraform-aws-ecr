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
