# terraform-aws-ecr

Terraform module to create AWS ECR resources.

## Default configurations

- Tag image mutability to `IMMUTABLE`.
- Scanning image on push with `BASIC` mode.
- Encryption type with `AES256`.
- Always having a tag called `ManagedBy` with value `Terraform`

## Usage

### Basic Repository
```hcl
module "ecr" {
  source = "git::git@github.com:cauealvesbraz/terraform-aws-ecr.git?ref=v1.0.0"

  name = "basic-repository-example"

  force_delete = true
  image_tag_mutability = "MUTABLE"

  tags = {
    environment = "dev"
  }
}
```

### Registry Scanning Configuration

The `image_scanning_configuration` block supports the following:
```hcl
registry_scanning_configuration = object({
  scan_type = string
  rules = optional(list(object({
    scan_frequency = string
    repository_filter = object({
      filter = string
    })
  })))
})
```

The following example shows how to create a repository with registry scanning configuration.
```hcl
module "ecr" {
  source = "git::git@github.com:cauealvesbraz/terraform-aws-ecr.git?ref=v1.0.0"

  name = "basic-repository-example"

  force_delete = true
  image_tag_mutability = "MUTABLE"

  registry_scanning_configuration = {
    scan_type = "ENHANCED"
    rules = [
      {
        scan_frequency = "CONTINUOUS_SCAN"
        repository_filter = {
          filter = "*"
        }
      }
    ]
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
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the repository. | `string` | `""` | yes |
| `encryption.type` | Encryption configuration of the repository. | `string` | `AES256` | no |
| `encryption.kms_key` | The ARN of KMS key. | `string` | `""` | no |
| `image_tag_mutability` | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. | `string` | `"IMMUTABLE"` | no |
| `force_delete` | If true, will delete the repository even if it contains images. | `boolean` | `false` | no |
| `scan_on_push` | Indicates whether images are scanned after being pushed to the repository. | `boolean` | `true` | no |
| `registry_scanning_configuration` | The registry scanning configuration | `object` | `object.scan_type = "BASIC"` | no |
| `tags` | A map of tags to add to resources | `map(string)` | `{}` | no |


## Outputs

| Name | Description |
|------|-------------|
| `repository_arn` | Full ARN of the repository |
| `registry_id` | The registry ID of the repository |
| `repository_url` | The URL of the repository |

## License

MIT
