data "aws_eks_cluster" "cluster" {
  name = "argo-staging-01"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = "argo-staging-01"
}