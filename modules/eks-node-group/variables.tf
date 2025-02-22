variable "aws_region" {
  type        = string
  description = "The AWS region where the EKS cluster and other resources will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to be applied to all AWS resources, useful for categorization and cost allocation"
}

variable "eks_version" {
  type        = string
  description = "The version of Amazon EKS to be deployed"
}

variable "node_min" {
  type        = string
  description = "The minimum number of nodes in the node group for the EKS cluster"
}

variable "desired_node" {
  type        = string
  description = "The desired number of nodes in the node group for the EKS cluster"
}

variable "node_max" {
  type        = string
  description = "The maximum number of nodes allowed in the node group for the EKS cluster"
}

variable "blue_node_color" {
  type        = string
  description = "The color identifier for blue nodes in the deployment"
}

variable "green_node_color" {
  type        = string
  description = "The color identifier for green nodes in the deployment"
}

variable "blue" {
  type        = bool
  description = "Boolean to indicate whether the blue environment is being deployed"
}

variable "green" {
  type        = bool
  description = "Boolean to indicate whether the green environment is being deployed"
}

variable "ec2_ssh_key" {
  type        = string
  description = "The SSH key pair to use for accessing EC2 instances (nodes) via a bastion host"
}

variable "deployment_nodegroup" {
  type        = string
  description = "The name of the node group being used for application deployment"
}

variable "capacity_type" {
  type        = string
  description = "The capacity type for the nodes. Valid values: ON_DEMAND, SPOT"
}

variable "ami_type" {
  type        = string
  description = "The type of AMI to be used for nodes in the EKS cluster. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64"
}

variable "instance_types" {
  type        = string
  description = "The EC2 instance type(s) to be used for the node group. At least t3.medium should be specified"
}

variable "disk_size" {
  type        = string
  description = "The size of the EBS volume (in GiB) to be attached to each node"
}

variable "shared_owned" {
  type        = string
  description = "Specifies the ownership of the resources. Valid values: shared, owned"
}

variable "enable_cluster_autoscaler" {
  type        = bool
  description = "Indicates whether to enable cluster autoscaler. Valid values: true, false"
}

variable "control_plane_name" {
  type        = string
  description = "The name of the EKS control plane (cluster) that manages the worker nodes"
}

variable "private_subnet" {
  type = map(string)
}