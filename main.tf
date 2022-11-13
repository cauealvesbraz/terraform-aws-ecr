resource "aws_ecr_repository" "this" {
  name = var.name

  encryption_configuration {
    encryption_type = var.encryption.type
    kms_key         = var.encryption.kms_key
  }

  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  force_delete = var.force_delete

  tags = merge(
    var.tags, {
      "ManagedBy" : "Terraform"
    }
  )
}

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = try(var.registry_scanning_configuration.scan_type, "") == "" ? 0 : 1

  scan_type = var.registry_scanning_configuration.scan_type
  dynamic "rule" {
    for_each = var.registry_scanning_configuration.rules
    content {
      scan_frequency = rule.value.scan_frequency
      repository_filter {
        filter = rule.value.repository_filter.filter
        filter_type = "WILDCARD"
      }
    }
  }
}
