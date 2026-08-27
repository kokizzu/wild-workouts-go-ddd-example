provider "google" {
  project = var.project
  region  = var.region

  # Some APIs (e.g. firebase.googleapis.com) refuse user credentials without a
  # quota project. The provider doesn't pick up the one from the gcloud ADC file,
  # so it has to be set here.
  user_project_override = true
  billing_project       = var.project
}

data "google_billing_account" "account" {
  display_name = var.billing_account
}

resource "google_project" "project" {
  name            = "Wild Workouts"
  project_id      = var.project
  billing_account = data.google_billing_account.account.id
  deletion_policy = var.project_deletion_policy

  lifecycle {
    ignore_changes = [org_id]
  }
}

resource "google_project_iam_member" "owner" {
  project = google_project.project.project_id
  role    = "roles/owner"
  member  = "user:${var.user}"
}

resource "google_project_service" "compute" {
  service    = "compute.googleapis.com"
  depends_on = [google_project.project]
}

resource "google_project_service" "artifact_registry" {
  service    = "artifactregistry.googleapis.com"
  depends_on = [google_project.project]

  disable_dependent_services = true
}

resource "google_project_service" "cloud_run" {
  service    = "run.googleapis.com"
  depends_on = [google_project.project]
}

resource "google_project_service" "iam_credentials" {
  service    = "iamcredentials.googleapis.com"
  depends_on = [google_project.project]
}

resource "google_project_service" "firebase" {
  service    = "firebase.googleapis.com"
  depends_on = [google_project.project]

  disable_dependent_services = true
}

resource "google_project_service" "firestore" {
  service    = "firestore.googleapis.com"
  depends_on = [google_project.project]
}
