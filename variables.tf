variable "gcp_project_id" {}

variable "region" {
  type        = string
  default     = "asia-northeast1"
  description = "GCP region"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-2"
  description = "Node pool machine type"
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Number of GKE nodes"
}

variable "gke_version" {
  type        = string
  default     = "1.16.15-gke.4300"
  description = "GKE version"
}