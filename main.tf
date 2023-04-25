resource "doppler_project" "this" {
  name        = var.project_name
  description = var.project_description == "" ? null : var.project_description
}

resource "doppler_environment" "this" {
  project = doppler_project.this.name
  slug    = var.environment_slug
  name    = var.environment_name
}

resource "doppler_config" "this" {
  name        = "${doppler_environment.this.slug}_${var.config_name}"
  project     = doppler_project.this.name
  environment = doppler_environment.this.slug
}

resource "doppler_secret" "this" {
  for_each = var.secrets
  project  = doppler_project.this.name
  config   = doppler_environment.this.id
  name  = each.key
  value = each.value
}

resource "doppler_service_token" "this" {
  for_each = var.is_service_token_required ? toset([var.service_token_name]) : toset([])
  name    = each.key
  project = doppler_project.this.name
  config  = doppler_environment.this.id
  access  = var.service_token_access
}