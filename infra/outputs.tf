output "growi_url" {
  value = "http://${aws_eip.growi.public_ip}:3000"
}
