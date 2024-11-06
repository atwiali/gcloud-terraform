# Step 0: Create a new Google Cloud project with the name "starlake-dev"
resource "google_project" "starlake_dev" {
  name       = var.project_name     # Name of the new project
  project_id = var.project_id       # Unique project ID for "starlake-dev"
  org_id     = var.organization_id  # Your GCP organization ID
  billing_account = var.billing_account_id  # Billing account ID
}

# Provider configuration for the created project, with an alias
provider "google" {
  project = google_project.starlake_dev.project_id  # Project ID for new resources
  region  = var.region
  alias   = "starlake_dev"
}

# Step 1: Create a Google Cloud service account.
resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  provider     = google.starlake_dev  # Use the aliased provider
}

# Step 2: Assign Cloud Run Admin role to the service account.
resource "google_project_iam_binding" "run_admin_role" {
  project = google_project.starlake_dev.project_id
  role    = "roles/run.admin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
  provider = google.starlake_dev  # Use the aliased provider
}

# Step 3: Assign Storage Admin role to the service account.
resource "google_project_iam_binding" "storage_admin_role" {
  project = google_project.starlake_dev.project_id
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
  provider = google.starlake_dev  # Use the aliased provider
}

# Step 4: Create a key for the service account.
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  provider           = google.starlake_dev  # Use the aliased provider
}

# Step 5: Create a Google Artifact Registry repository.
resource "google_artifact_registry_repository" "artifact_registry" {
  location      = var.region
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  provider      = google.starlake_dev  # Use the aliased provider
}

# Step 6: Tag and push a Docker image to Artifact Registry.
resource "null_resource" "docker_tag_push" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "sudo docker tag ${var.image_name} ${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}:${var.docker_image_version}"
  }
  provisioner "local-exec" {
    command = "sudo docker push ${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}:${var.docker_image_version}"
  }
}

# Step 7: Deploy a Cloud Run service using the pushed Docker image.
resource "google_cloud_run_service" "cloud_run_service" {
  name       = "my-cloud-run-service"
  location   = var.region
  depends_on = [null_resource.docker_tag_push]
  provider   = google.starlake_dev  # Use the aliased provider

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}:${var.docker_image_version}"
      }
    }
  }

  autogenerate_revision_name = true
}

# Step 8: Allow public (unauthenticated) access to the Cloud Run service.
resource "google_cloud_run_service_iam_member" "no_auth_permission" {
  location = google_cloud_run_service.cloud_run_service.location
  project  = var.project_id
  service  = google_cloud_run_service.cloud_run_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
  provider = google.starlake_dev  # Use the aliased provider
}
