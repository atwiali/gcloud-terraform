resource "google_project_iam_binding" "run_admin_role" {
  project = var.project_id
  role    = "roles/run.admin"
  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "google_project_iam_binding" "storage_admin_role" {
  project = var.project_id
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}
