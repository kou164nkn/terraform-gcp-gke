resource "google_container_cluster" "deploy-gke" {
  name     = "deploy-gke-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.32/28"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }
}


resource "google_container_node_pool" "deploy-gke" {
  name       = "${google_container_cluster.deploy-gke.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.deploy-gke.name
  node_count = var.node_count
  version    = var.gke_version

  node_config {
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = google_service_account.gke_node_pool.email
  }
}


resource "google_service_account" "gke_node_pool" {
  account_id   = "gke-node-pool-sa"
  display_name = "GKE Node Service Account"
}


resource "google_project_iam_member" "gke_node_pool_role" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer"
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.gke_node_pool.email}"
}