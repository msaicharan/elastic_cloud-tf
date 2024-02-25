# THIS FILE IS MANAGED VIA AN AUTOMATED RENDERING PROCESS. CHANGES WILL BE OVERWRITTEN.

module "ec_setup" {
  source                         = "git::https://github.com/msaicharan/elastic_cloud-tf.git?ref=main" # TODO: set tag
  deployment_name                = var.deployment_name
  region                         = var.region
  ec_version                     = var.ec_version
  autoscale                      = var.autoscale
  deployment_template_id         = var.deployment_template_id
  frozen_size                    = var.frozen_size
  frozen_count                   = var.frozen_count
  frozen_size_def                = var.frozen_size_def
  hot_size                       = var.hot_size
  hot_count                      = var.hot_count
  hot_size_def                   = var.hot_size_def
  kibana_size                    = var.kibana_size
  kibana_count                   = var.kibana_count
  integrations_server_size       = var.integrations_server_size
  integrations_server_count      = var.integrations_server_count
  client_ad_group                = var.client_ad_group
  client_lifecycle               = var.client_lifecycle
  ec_api_key                     = var.ec_api_key
  ec_keystore_oidc_client_secret = var.ec_keystore_oidc_client_secret
  ec_keystore_oidc_client_id     = var.ec_keystore_oidc_client_id
  ec_oidc_base_url               = var.ec_oidc_base_url
}
