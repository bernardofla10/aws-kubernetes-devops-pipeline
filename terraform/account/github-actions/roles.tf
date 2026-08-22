data "aws_iam_policy_document" "terraform_plan_assume" {
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
resource "aws_iam_role" "terraform_plan" {
  name = "${var.project_name}-terraform-plan"

  assume_role_policy = (
    data.aws_iam_policy_document.terraform_plan_assume.json
  )
}
resource "aws_iam_role_policy_attachment" "terraform_plan_readonly" {
  role = aws_iam_role.terraform_plan.name

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
data "aws_iam_policy_document" "terraform_plan_state" {
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.terraform_state_bucket_arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.terraform_state_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_plan_state" {
  name = "terraform-state-read"

  role = aws_iam_role.terraform_plan.id

  policy = data.aws_iam_policy_document.terraform_plan_state.json
}
data "aws_iam_policy_document" "terraform_apply_assume" {
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
        "${var.github_subject_prefix}:environment:${var.environment}"
      ]
    }
  }
}
resource "aws_iam_role" "terraform_apply" {
  name = "${var.project_name}-terraform-apply-${var.environment}"

  assume_role_policy = (
    data.aws_iam_policy_document.terraform_apply_assume.json
  )
}
resource "aws_iam_role_policy_attachment" "terraform_apply_poweruser" {
  role = aws_iam_role.terraform_apply.name

  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
data "aws_iam_policy_document" "terraform_apply_iam" {
  statement {
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",

      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",

      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",

      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::*:role/${var.project_name}-*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_apply_iam" {
  name = "terraform-project-iam"

  role = aws_iam_role.terraform_apply.id

  policy = data.aws_iam_policy_document.terraform_apply_iam.json
}
