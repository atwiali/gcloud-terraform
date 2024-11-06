variable "image_name" {
  type        = string
  description = "The name of the Docker image to push"
}

variable "image_uri" {
  type        = string
  description = "The URI of the Artifact Registry repository"
}

variable "image_version" {
  type        = string
  description = "The version of the Docker image"
}
