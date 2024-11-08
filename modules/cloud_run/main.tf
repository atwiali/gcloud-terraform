resource "google_cloud_run_service" "cloud_run_service" {
  name       = var.service_name
  location   = var.region
  project = var.project_id

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "no_auth_permission" {
  location = google_cloud_run_service.cloud_run_service.location
  project  = var.project_id
  service  = google_cloud_run_service.cloud_run_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
