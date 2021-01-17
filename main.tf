provider "google" {
  project  = var.gcp_project_id
  region   = var.region
}

terraform {
  required_version = "~>0.14.0"

  backend "gcs" {
    bucket = "kou-terraform-gcp"
    prefix = "terraform/gke-deploy"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.52.0"
    }
  }
}