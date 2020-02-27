clusters = {
  gke_zero = {
    # Settings for Apps-cluster
    apps = {
      # The Google cloud project ID to use
      project_id = "microservice-demo-268111"

      # Set name_prefix used to generate the cluster_name
      # [name_prefix]-[workspace]-[region]
      # e.g. name_prefix = kbst becomes: `kbst-apps-europe-west3`
      # for small orgs the name works well,
      # for bigger orgs consider department or team names
      name_prefix = "kbst"

      # Set the base_domain used to generate the FQDN of the cluster
      # [cluster_name].[provider_name].[base_domain]
      # e.g. kbst-apps-europe-west3.gcp.infra.example.com
      base_domain = "infra.example.com"

      # Initial desired K8s version, will be upgraded automatically
      cluster_min_master_version = "1.15.9"

      # Initial number of desired nodes per zone
      cluster_initial_node_count = 1

      # The Google cloud region to deploy the clusters in
      region = "europe-west4"

      # Comma seperated list of zone names to deploy worker nodes in.
      # Must match region above.
      # e.g. cluster_node_locations = "europe-west3-a,europe-west3-b,europe-west3-c"
      # FIXME: Use actual list when TF 0.12 finally supports heterogeneous maps
      cluster_node_locations = "europe-west4-a,europe-west4-b,europe-west4-c"

      # Allow autoscaling between 1 and 3 nodes per zone
      cluster_min_node_count = 1
      cluster_max_node_count = 3
    }

    # Settings for Ops-cluster
    # configuration here overwrites the values from apps
    ops = {
      # Overwrite apps["cluster_node_locations"] to have a smaller
      # ops cluster
      # e.g. cluster_node_locations = "europe-west3-a"
      cluster_node_locations = "europe-west4-a,europe-west4-b"

      # Allow autoscaling between 1 and 3 nodes per zone
      cluster_min_node_count = 1
      cluster_max_node_count = 2
    }
  }
}
