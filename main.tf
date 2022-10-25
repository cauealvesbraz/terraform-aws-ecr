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
