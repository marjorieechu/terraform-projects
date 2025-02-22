resource "kubernetes_storage_class" "aws-storage-class" {
  metadata {
    name = format("%s-%s-sc", var.tags["environment"], var.tags["project"])
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Retain" //"Retain" or "Delete"
  storage_provisioner    = "ebs.csi.aws.com"
  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }
}