# terraform-aws-ecr

Terraform module to create AWS ECR resources.

## Default configurations

- Tag image mutability to `IMMUTABLE`.
- Scanning image on push with `BASIC` mode.
- Encryption type with `AES256`.
- Always having a tag called `managed-by` with value `terraform`

## Usage

### Basic Repository
```hcl
module "ecr" {
  source = "github.com/cauealvesbraz/terraform-aws-ecr"

  repository_name = "basic-example"
  
  force_delete = true
  image_tag_mutability = "MUTABLE"
  
  tags = {
    environment = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| `terraform` | >= 1.32.2 |
| `hashicorp/aws` | >= 4.34 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the repository. | `string` | `""` | yes |
| `encryption.type` | Encryption configuration of the repository. | `string` | `AES256` | no |
| `encryption.kms_key` | The ARN of KMS key. | `string` | `""` | no |
| `image_tag_mutability` | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. | `string` | `"IMMUTABLE"` | no |
| `force_delete` | If true, will delete the repository even if it contains images. | `boolean` | `false` | no |
| `scan_on_push` | Indicates whether images are scanned after being pushed to the repository. | `boolean` | `true` | no |
| `tags` | A map of tags to add to resources | `map(string)` | `true` | no |


## Outputs

| Name | Description |
|------|-------------|
| `repository_arn` | Full ARN of the repository |
| `registry_id` | The registry ID of the repository |
| `repository_url` | The URL of the repository |

## License

MIT
