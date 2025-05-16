module "access" {
  source = "./modules/access"

  account_id = var.account_id
  app_name   = var.app_name

  # Use the group IDs from the IDP module outputs
  red_team_group_id  = module.idp.red_team_id
  blue_team_group_id = module.idp.blue_team_id
  red_team_id        = module.idp.red_team_id
  blue_team_id       = module.idp.blue_team_id

  # Azure AD configuration
  azure_ad_provider_id = module.idp.entra_idp_id

  # App domains
  red_team_app_domain  = var.red_team_app_domain
  blue_team_app_domain = var.blue_team_app_domain

  # Email access
  allowed_emails = var.allowed_emails
} 