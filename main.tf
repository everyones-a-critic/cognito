terraform {
  cloud {
    organization = "everyones-a-critic"
    workspaces {
      name = "cognito"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ses_email_identity" "welcome" {
  email = "welcome@everyonesacriticapp.com"
}

resource "aws_cognito_user_pool" "main" {
  name             = "everyones-a-critic"
  alias_attributes = ["email", "preferred_username"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    source_arn            = aws_ses_email_identity.welcome.arn
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  username_configuration {
    case_sensitive = false
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "react-native-client"
  user_pool_id = aws_cognito_user_pool.main.id

  access_token_validity   = 60
  refresh_token_validity  = 30
  id_token_validity       = 60
  enable_token_revocation = true

  allowed_oauth_flows_user_pool_client = false
  allowed_oauth_flows                  = []
  allowed_oauth_scopes                 = []
  callback_urls                        = []
  supported_identity_providers         = []
  logout_urls                          = []
  prevent_user_existence_errors        = "ENABLED"
  generate_secret                      = false

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  read_attributes = [
    "email",
    "email_verified",
    "family_name",
    "given_name",
    "middle_name",
    "name",
    "nickname",
    "preferred_username",
    "updated_at"
  ]

  write_attributes = [
    "email",
    "family_name",
    "given_name",
    "middle_name",
    "name",
    "nickname",
    "preferred_username",
    "updated_at"
  ]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}