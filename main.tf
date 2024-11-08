provider "google" {
  project = var.project_id
  region  = var.region
}
module "project" {
  source            = "./modules/project"
  project_name      = var.project_name
  project_id        = var.project_id
  organization_id   = var.organization_id
  billing_account_id = var.billing_account_id
}

module "service_account" {
  source      = "./modules/service_account"
  account_id  = var.account_id
  display_name = var.display_name
  project_id = var.project_id
}

module "artifact_registry" {
  source         = "./modules/artifact_registry"
  region         = var.region
  repository_id  = var.repository_id
  description    = var.description
  format         = var.format
}

module "docker_push" {
  source       = "./modules/docker_push"
  image_name   = var.image_name
  image_uri    = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}"
  image_version = var.docker_image_version
}

module "cloud_run" {
  source       = "./modules/cloud_run"
  project_id   = var.project_id
  region       = var.region
  service_name = "my-cloud-run-service"
  image        = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}:${var.docker_image_version}"
}
