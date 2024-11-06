resource "google_cloud_run_service" "cloud_run_service" {
  name       = var.service_name
  location   = var.region
  provider   = google.starlake_dev
  depends_on = [null_resource.docker_tag_push]

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
