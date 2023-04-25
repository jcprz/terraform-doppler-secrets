locals {
  common_secrets = {
    "MY_VAR_1" : var.var_one,
    "MY_VAR_2" : var.var_two
  }

  dynamic_secrets = {
    "my-app-repo-a" = {},
    "my-app-repo-b"   = {},
    "my-app-repo-c" = {},
    # Add more repositories as needed
  }

  repos = {
    for repo, _ in local.dynamic_secrets :
    repo => merge(
      local.common_secrets,
      {
        "TF_GCP_JSON_KEY"   = var.gcp_json_key
        "TF_GCP_PROJECT"    = var.gcp_project
        "TF_GKE_NAME"       = var.gke.name,
      }
    )
  }
}
module "doppler_secret" {
  for_each = local.repos

  source = "git::ssh://git@github.com/jcprz/terraform-doppler-secrets.git?ref=v0.1"

  doppler_token = var.doppler_token # picked up from doppler in TF plan

  project_name = each.key
  config_name = each.key

  project_description = "${each.key} project"

  environment_name = "DEV"

  environment_slug = "dev"

  secrets = each.value
  is_service_token_required = false

}
