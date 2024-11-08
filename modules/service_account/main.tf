resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}


resource "google_project_iam_binding" "run_admin_role" {
  project = var.project_id
  role    = "roles/run.admin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "storage_admin_role" {
  project = var.project_id
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}
