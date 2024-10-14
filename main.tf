provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a service account
resource "google_service_account" "service_account" {
  account_id   = "my-service-account"
  display_name = "My Service Account"
}

# Assign Cloud Run Admin role to the service account
resource "google_project_iam_binding" "run_admin_role" {
  project = var.project_id
  role    = "roles/run.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

# Assign Storage Admin role to the service account
resource "google_project_iam_binding" "storage_admin_role" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

# Create a service account key
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# Deploy Cloud Run service
resource "google_cloud_run_service" "cloud_run_service" {
  name     = "my-cloud-run-service"
  location = var.region
// to be change the image
  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  autogenerate_revision_name = true
}

# Set permissions for the Cloud Run service to be unauthenticated
resource "google_cloud_run_service_iam_member" "no_auth_permission" {
  location = google_cloud_run_service.cloud_run_service.location
  project  = var.project_id
  service  = google_cloud_run_service.cloud_run_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
