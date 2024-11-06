resource "null_resource" "docker_tag_push" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "docker tag ${var.image_name} ${var.image_uri}:${var.image_version}"
  }
  provisioner "local-exec" {
    command = "docker push ${var.image_uri}:${var.image_version}"
  }
}
