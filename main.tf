provider "google" {
  project  = var.gcp_project_id
  region   = var.region
}

terraform {
  required_version = ">=0.12.0"

  backend "gcs" {
    bucket = "kou-terraform-gcp"
    prefix = "terraform/gke-deploy"
  }
}