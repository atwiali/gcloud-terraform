resource "google_artifact_registry_repository" "artifact_registry" {
  location      = var.region
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  project = var.project_id
}

resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  depends_on = [ google_artifact_registry_repository.artifact_registry ]
}