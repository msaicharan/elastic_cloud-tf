variable "ec_api_key" {
  type = string
}
variable "ec_keystore_oidc_client_id" {
  type = string
}
variable "ec_keystore_oidc_client_secret" {
  type = string
}
variable "ec_oidc_base_url" {
  type = string
}
variable "deployment_name" {
  type = string
}
variable "region" {
  type    = string
  default = "us-east-2"
}
variable "ec_version" {
  type    = string
  default = "8.9.2"
}
variable "autoscale" {
  type    = string
  default = "true"
}
variable "deployment_template_id" {
  type    = string
  default = "aws-storage-optimized"
}
variable "hot_size" {
  type    = string
  default = "4g"
}
variable "hot_count" {
  type    = number
  default = 1
}
variable "hot_size_def" {
  type    = string
  default = "2g"
}
variable "frozen_size" {
  type    = string
  default = "4g"
}
variable "frozen_count" {
  type    = number
  default = 0
}
variable "frozen_size_def" {
  type    = string
  default = "0g"
}
variable "kibana_size" {
  type    = string
  default = "2g"
}
variable "kibana_count" {
  type    = number
  default = 1
}
variable "integrations_server_size" {
  type    = string
  default = "1g"
}
variable "integrations_server_count" {
  type    = number
  default = 1
}
variable "client_ad_group" {
  type    = string
  default = "some-admins"
}

