variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy Cloud Run"
  type        = string
}

variable "account_id" {
  description = "The ID of the service account"
  type        = string
}

variable "display_name" {
  description = "The display name of the service account"
  type        = string
}


variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

variable "description" {
  description = "The description of the Artifact Registry repository"
  type        = string
}

variable "format" {
  description = "The format of the Artifact Registry repository"
  type        = string
}

variable "docker_image_version" {
  description = "The version of the Docker image"
  type        = string
}

variable "image_name" {
  description = "The name of the image"
  type        = string
}
