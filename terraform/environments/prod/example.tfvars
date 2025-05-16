# Example Terraform variables file
# Copy this to terraform.tfvars and update with your values

account_id           = "your-cloudflare-account-id"
api_token            = "your-cloudflare-api-token"
azure_client_id      = "your-azure-client-id"
azure_client_secret  = "your-azure-client-secret"
azure_directory_id   = "your-azure-directory-id"
intune_client_id     = "your-intune-client-id"     # Usually same as azure_client_id
intune_client_secret = "your-intune-client-secret" # Usually same as azure_client_secret

# Red team configuration
red_team_name      = "Red Team"
red_team_group_ids = ["4bcdb329-9bdc-4954-a472-db14805b1bf0"] # Note the square brackets for list format

# Blue team configuration
blue_team_name      = "Blue Team"
blue_team_group_ids = ["03eb955d-3359-401e-a127-5a0ebafcea86"] # Note the square brackets for list format