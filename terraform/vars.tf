variable "project" {}
variable "user" {}
variable "region" {}
variable "firebase_location" {}

variable "billing_account" {
  description = "Billing account display name"
}

variable "github_repository" {
  description = "GitHub repository (owner/name) allowed to deploy via GitHub Actions"
  default     = "ThreeDotsLabs/wild-workouts-go-ddd-example"
}

variable "project_deletion_policy" {
  description = "What terraform destroy may do to the project. PREVENT protects a long-lived one."
  default     = "DELETE"

  validation {
    condition     = contains(["PREVENT", "ABANDON", "DELETE"], var.project_deletion_policy)
    error_message = "Must be one of PREVENT, ABANDON, or DELETE."
  }
}
