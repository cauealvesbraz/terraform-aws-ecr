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

## Lifecycle policy
variable "lifecycle_policy" {
  type = object({
    rules = list(object({
      rulePriority = number
      description = optional(string)
      selection = object({
        tagStatus   = string
        countType   = string
        countNumber = number
        countUnit   = string
        tagPrefixList = optional(list(string))
      }),
      action = object({
        type = string
      })
    }))
  })

  default = {
    rules = []
  }

  description = "(Optional) A lifecycle policy for the repository. Default is empty"

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : contains(
        ["tagged", "untagged", "any"],
        rule.selection.tagStatus
      )
    ])

    error_message = "The tag status must be one of: tagged, untagged or any."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : contains(
        ["sinceImagePushed", "sinceImageCreated"],
        rule.selection.countType
      )
    ])

    error_message = "The count type must be one of: sinceImagePushed or sinceImageCreated."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : contains(
        ["days", "weeks", "months"],
        rule.selection.countUnit
      )
    ])

    error_message = "The count unit must be one of: days, weeks or months."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : rule.selection.countNumber > 0
    ])

    error_message = "The count number must be greater than 0."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : rule.rulePriority > 0
    ])

    error_message = "The priority must be greater than 0."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_policy.rules : contains(
        ["expire"],
        rule.action.type
      )
    ])

    error_message = "The action type must be one of: expire."
  }
}

## Tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to resources"
}
