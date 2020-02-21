module "gke_zero" {
  source = "github.com/kbst/terraform-kubestack//google/cluster?ref=master"

  configuration = var.clusters["gke_zero"]
}
