output "helm_release_status" {
  description = "The status of the ingress helm release"
  value       = helm_release.nginx_ingress.status
}