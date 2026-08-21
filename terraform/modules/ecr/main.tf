resource "aws_ecr_repository" "this" {
  name = var.repository_name

  image_tag_mutability = "IMMUTABLE"

  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = (
      var.kms_key_arn != null ? "KMS" : "AES256"
    )

    kms_key = var.kms_key_arn
  }

  tags = merge(
    var.tags,
    {
      Component = "container-registry"
    }
  )
}