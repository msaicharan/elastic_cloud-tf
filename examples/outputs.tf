# THIS FILE IS MANAGED VIA AN AUTOMATED RENDERING PROCESS. CHANGES WILL BE OVERWRITTEN.
output "elasticsearch_deployment_id" {
  value = module.ec_setup.depl_id
}

output "elasticsearch_endpoint" {
  value = module.ec_setup.elasticsearch_endpoint
}

output "kibana_endpoint" {
  value = module.ec_setup.kibana_endpoint
}

output "elasticsearch_username" {
  value = module.ec_setup.elasticsearch_username
}

output "elasticsearch_password" {
  value     = module.ec_setup.elasticsearch_password
  sensitive = true
}