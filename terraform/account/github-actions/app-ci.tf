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
