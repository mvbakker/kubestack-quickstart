module "gke_zero" {
  source = "github.com/kbst/terraform-kubestack//google/cluster?ref=608dcfad3191ba90f180b4b04da640cef751ef9c"

  configuration = var.clusters["gke_zero"]
}
