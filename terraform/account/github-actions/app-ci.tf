data "aws_caller_identity" "current" {}

locals {
  ecr_repository_name = "${var.project_name}/vaultwarden"

  ecr_repository_arn = join(
    "",
    [
      "arn:aws:ecr:",
      var.aws_region,
      ":",
      data.aws_caller_identity.current.account_id,
      ":repository/",
      local.ecr_repository_name
    ]
  )
}

data "aws_iam_policy_document" "app_ci_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "${var.github_subject_prefix}:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "app_ci" {
  name = "${var.project_name}-app-ci"

  assume_role_policy = (
    data.aws_iam_policy_document.app_ci_assume.json
  )
}

data "aws_iam_policy_document" "app_ci_ecr" {
  statement {
    sid = "ECRAuthentication"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid = "RepositoryAccess"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      local.ecr_repository_arn
    ]
  }
}

resource "aws_iam_role_policy" "app_ci_ecr" {
  name = "ecr-publisher"

  role = aws_iam_role.app_ci.id

  policy = data.aws_iam_policy_document.app_ci_ecr.json
}
