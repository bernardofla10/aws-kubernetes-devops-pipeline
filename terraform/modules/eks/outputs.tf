output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  value = aws_eks_cluster.this.version
}

output "node_group_name" {
  value = aws_eks_node_group.general.node_group_name
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "vpc_cni_role_arn" {
  value = aws_iam_role.vpc_cni.arn
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi.arn
}