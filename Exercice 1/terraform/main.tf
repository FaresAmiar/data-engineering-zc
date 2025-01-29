terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
#  credentials = 
  project = "ivory-analyst-447323-n5"
  region  = "europe-west9"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name          = "goku-ssjgod1"
  location      = "europe-west9"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "saiyajin"
  project    = "ivory-analyst-447323-n5"
  location   = "europe-west9"
}