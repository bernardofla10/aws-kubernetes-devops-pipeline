locals {
  managed_addons = toset([
    "eks-pod-identity-agent",
    "vpc-cni",
    "kube-proxy",
    "coredns",
    "aws-ebs-csi-driver"
  ])
}

data "aws_eks_addon_version" "latest" {
  for_each = local.managed_addons

  addon_name         = each.key
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "eks-pod-identity-agent"

  addon_version = data.aws_eks_addon_version.latest[
    "eks-pod-identity-agent"
  ].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "vpc-cni"

  addon_version = data.aws_eks_addon_version.latest[
    "vpc-cni"
  ].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  pod_identity_association {
    role_arn        = aws_iam_role.vpc_cni.arn
    service_account = "aws-node"
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.vpc_cni
  ]

  tags = var.tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "coredns"

  addon_version = data.aws_eks_addon_version.latest[
    "coredns"
  ].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general
  ]

  tags = var.tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "kube-proxy"

  addon_version = data.aws_eks_addon_version.latest[
    "kube-proxy"
  ].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.general
  ]

  tags = var.tags
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.this.name

  addon_name = "aws-ebs-csi-driver"

  addon_version = data.aws_eks_addon_version.latest[
    "aws-ebs-csi-driver"
  ].version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  pod_identity_association {
    role_arn        = aws_iam_role.ebs_csi.arn
    service_account = "ebs-csi-controller-sa"
  }

  depends_on = [
    aws_eks_node_group.general,
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.ebs_csi
  ]

  tags = var.tags
}