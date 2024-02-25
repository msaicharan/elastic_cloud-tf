output "depl_id" {
  value = ec_deployment.elastic_deployment.id
}

output "elasticsearch_endpoint" {
  value = local.elasticsearch_endpoint
}

output "kibana_endpoint" {
  value = local.kibana_endpoint
}

output "elasticsearch_username" {
  value = ec_deployment.elastic_deployment.elasticsearch_username
}

output "elasticsearch_password" {
  value     = ec_deployment.elastic_deployment.elasticsearch_password
  sensitive = true
}

output "elasticsearch_alias" {
  value = ec_deployment.elastic_deployment.alias
}

output "elasticsearch_deployment_id" {
  value = ec_deployment.elastic_deployment.id
  sensitive = true
}

output "elasticsearch_cluster_id" {
  value = ec_deployment.elastic_deployment.elasticsearch
  sensitive = true
}

output "elasticsearch_data" {
  value = ec_deployment.elastic_deployment.elasticsearch
  sensitive = true
}

output "kibana_data" {
  value = ec_deployment.elastic_deployment.kibana
  sensitive = true
}