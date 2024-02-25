# Installing all the required Terraform providers.
terraform {
  required_version = ">= 0.13.1"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    ec = {
      source  = "elastic/ec"
      version = "0.9.0"
    }
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "0.5.0"
    }
  }
}

#Providing elastic cloud API key. Thsi API key is bind to elastic account, enabled ot perform all operations on Elastic cloud.
provider "ec" {
  apikey = var.ec_api_key
}

#Creating a random ID which is used in naming convention. This actually helps in resolving circular dependency between Kibana URL and elasticsearch config file. 
resource "random_uuid" "uuid" {}


# Creating a deployment in Elastic cloud. This deployment is a combination of Elasticsearch, Kibana, and Integrations server.
resource "ec_deployment" "elastic_deployment" {

  # Create a name and alias for elastic deployment.  
  name  = format("%s-%s", var.deployment_name, substr(random_uuid.uuid.result, 0, 3))
  alias = format("%s-%s", var.deployment_name, substr(random_uuid.uuid.result, 0, 3))


  # Mandatory fields defining region, version and template 
  region                 = var.region
  version                = var.ec_version
  deployment_template_id = var.deployment_template_id

  elasticsearch = {
    autoscale = var.autoscale

    #Providing the user settings for elasticsearch. This is a yaml file which is used to configure the elasticsearch settings.
    config = {
      user_settings_yaml = templatefile("${path.module}/ec_user_settings.yaml.tftpl", {
        client_id       = var.ec_keystore_oidc_client_id
        base_url        = var.ec_oidc_base_url
        deployment_name = format("%s-%s", var.deployment_name, substr(random_uuid.uuid.result, 0, 3))
        region          = var.region
      })
    }

    #Providing the keystore contents for elasticsearch used for OIDC settings. 
    keystore_contents = {
      "xpack.security.authc.realms.oidc.oidc1.rp.client_secret" = {
        value = var.ec_keystore_oidc_client_secret
      }
    }

    # Defining the size and zone count for each node type. Alphabetically ordered as per Elastic cloud documentation.

    #Set cold to 0g if autoscale is enabled. Else do not set it. However the value can be set in the variable.
    cold = {
      autoscaling = var.autoscale ? {
        max_size          = "0g"
        max_size_resource = "memory"
      } : {}
    }

    #Set frozen to given max_size if autoscale is enabled. Else set it to the value provided in the variable.
    frozen = {
      size       = var.autoscale ? var.frozen_size_def : var.frozen_size
      zone_count = var.frozen_count

      autoscaling = var.autoscale ? {
        max_size          = var.frozen_size
        max_size_resource = "memory"
      } : {}
    }

    #Set hot to 0g if autoscale is enabled. Else do not set it. However the value can be set in the variable.
    hot = {
      size       = var.autoscale ? var.hot_size_def : var.hot_size
      zone_count = var.hot_count

      autoscaling = var.autoscale ? {
        max_size          = var.hot_size
        max_size_resource = "memory"
      } : {}
    }

    #Set ml to 0g if autoscale is enabled. Else do not set it. However the value can be set in the variable.
    ml = {
      autoscaling = var.autoscale ? {
        max_size          = "0g"
        max_size_resource = "memory"
      } : {}
    }

    #Set warm to 0g if autoscale is enabled. Else do not set it. However the value can be set in the variable.
    warm = {
      autoscaling = var.autoscale ? {
        max_size          = "0g"
        max_size_resource = "memory"
      } : {}
    }

  }

  #Defining the topology for Kibana and integrations server.
  kibana = {
    topology = {
      size       = var.kibana_size
      zone_count = var.kibana_count
    }
    config = {
      user_settings_yaml = file("${path.module}/kibana_user_settings.yaml")
    }
  }

  integrations_server = {
    topology = {
      size       = var.integrations_server_size
      zone_count = var.integrations_server_count
    }
  }

  # To be able to send the logs and metrics to same cluster. Can also set to a seperate cluster, provided the deployment ID for that cluster.
  observability = {
    deployment_id = "self"
  }

}


#Since we provided with a UUID and alias, the elasticsearch and Kibana endpoints can be easily known/obtained/predicted as below.
# If you do not provide a UUID and the deployment name exists in the AWS cloud region already, then elasticsearch will itself by default append a UUID to the deployment name.
# Hence it is always wiser to add a UUID by self and alias to the deployment, so in a way you have control on the elastic cluster name.

locals {
  elasticsearch_endpoint = format("https://%s-%s.es.%s.aws.found.io:9243", var.deployment_name, substr(random_uuid.uuid.result, 0, 3), var.region)
  kibana_endpoint        = format("https://%s-%s.kb.%s.aws.found.io:9243", var.deployment_name, substr(random_uuid.uuid.result, 0, 3), var.region)
}


#To create a role-mapping for Kibana access via AD groups. Custom use case examples : 
#USe provider elasticstack for all Elasticsearch related configurations. 

provider "elasticstack" {
  #Authentication to the elasticsearch cluster.
  elasticsearch {
    username  = "elastic"
    password  = resource.ec_deployment.elastic_deployment.elasticsearch_password
    endpoints = [local.elasticsearch_endpoint]
  }
}

#Creating a role mapping for Kibana access via AD groups.
resource "elasticstack_elasticsearch_security_role_mapping" "user-kibanaadmin" {
  name    = "kibana-admin"
  enabled = true
  roles = [
    "superuser"
  ]
  #Can create the rules as below for the AD groups.

  #Below examples shows on how can a role mapping with name kibana-admin can be created for the a given AD group. 
  #Rule 1: If the user is part of the AD group "cn=${var.client_ad_group},OU=xxx,DC=xxx,DC=xxx" and the realm is "oidc1", then the user is given the role "superuser".
  rules = jsonencode({
    any = [
      {
        all = [
          { field = { "realm.name" = "oidc1" } },
          { field = { "groups" = "cn=${var.client_ad_group},OU=xxx,DC=xxx,DC=xxx" } }

        ]
      },
      {
        all = [
          { field = { "realm.name" = "oidc1" } },
          { field = { "groups" = "cn=xxx,OU=xxx,DC=xxx,DC=xxx" } }
        ]
      }
    ]
  })
}


