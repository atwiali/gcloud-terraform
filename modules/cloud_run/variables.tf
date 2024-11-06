variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "region" {
  type        = string
  description = "The region for Cloud Run deployment"
}

variable "service_name" {
  type        = string
  description = "The name of the Cloud Run service"
}

variable "image" {
  type        = string
  description = "The image URI for Cloud Run"
}
