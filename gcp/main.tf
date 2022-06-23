resource "google_compute_network" "vpc" {
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.prefix}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.subnet_prefix
}

resource "google_container_cluster" "gke" {
  name     = "${var.prefix}-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "node_pool" {
  name       = "${google_container_cluster.gke.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gke.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.prefix
    }

    # preemptible  = true
    machine_type = var.nodes_type
    tags         = ["gke-node", "${var.prefix}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
