
aws_region = "us-east-1"
namespaces = [
    "aws-ebs-csi-driver",
    "aws-efs-csi-driver",
    "cluster-autoscaler",
    "external-dns",
    "metrics-server",
    "app",
    "datadog",
    "monitoring",
    "argocd",
    "security"
    ]
control_plane_name = "dev-del"

tags = {
  "owner"          = "EK TECH SOFTWARE SOLUTION"
  "environment"    = "dev"
  "project"        = "del"
  "create_by"      = "Terraform"
  "cloud_provider" = "aws"
}