resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

output "project_id" {
  value = google_project.project.project_id
}