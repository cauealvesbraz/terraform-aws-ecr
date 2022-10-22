resource "aws_ecr_repository" "this" {
  name = var.name

  encryption_configuration {
    encryption_type = var.encryption.type
    kms_key         = var.encryption.kms_key
  }

  image_tag_mutability = var.image_tag_mutability

  tags = merge(
    var.tags, {
      "managed-by": "terraform"
    }
  )
}
