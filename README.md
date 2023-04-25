# Terraform Doppler Secrets Module

This module helps you create and manage Doppler secrets, projects, environments, and service tokens.

## Requirements

- Terraform version 0.12.x or higher
- Doppler provider version 1.x or higher

## Usage

```hcl
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

module "doppler_multiple_repos_secret" {
  for_each = local.repos

  source = "git::ssh://git@github.com/jcprz/terraform-doppler-secrets.git?ref=v0.1"

  doppler_token = var.doppler_token

  project_name = each.key

  config_name = each.key

  project_description = "${each.key} project"

  environment_name = terraform.workspace

  environment_slug = lower(terraform.workspace)

  secrets                   = each.value
  is_service_token_required = false

}
```

## Input Variables

| Name                      | Description                                                                       | Type   | Default | Required |
|---------------------------|-----------------------------------------------------------------------------------|--------|---------|----------|
| doppler_token             | The Doppler API token                                                             | string | -       | yes      |
| project_name              | The name of the Doppler project                                                   | string | -       | yes      |
| config_name               | The name of the Doppler config                                                    | string | -       | yes      |
| project_description       | The description of the Doppler project                                            | string | ""      | no       |
| environment_name          | The name of the Doppler environment                                               | string | -       | yes      |
| environment_slug          | The slug for the Doppler environment                                              | string | -       | yes      |
| secrets                   | A map of secret names and their corresponding values to be stored in Doppler      | map    | -       | yes      |
| is_service_token_required | Whether to create a Doppler service token for this config                         | bool   | false   | no       |
| service_token_name        | The name of the Doppler service token (if \`is_service_token_required\` is true)    | string | ""      | no       |
| service_token_access      | The access level of the Doppler service token (if \`is_service_token_required\` is true) | string | "read"  | no       |

## Outputs

| Name            | Description                      |
|-----------------|----------------------------------|
| project_name    | The Doppler project name         |
| config_name     | The Doppler config name          |
| environment_slug| The Doppler environment slug     |

## License

[MIT](LICENSE)
