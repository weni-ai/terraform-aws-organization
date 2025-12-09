resource "aws_organizations_organization" "org" {
  count = var.already_exists ? 0 : 1

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "account.amazonaws.com",
    var.enable_aws_sso ? "sso.amazonaws.com" : "",
    var.enable_compute_optimizer ? "compute-optimizer.amazonaws.com" : "",
    var.enable_cost_optimizer ? "cost-optimization-hub.bcm.amazonaws.com" : "",
  ]

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]

  feature_set = "ALL"
}

resource "aws_organizations_organization_service_access_status" "account_management" {
  service_principal = "account.amazonaws.com"
  count = var.already_exists ? 1 : 0
}

resource "aws_organizations_delegated_administrator" "alternate_contact_delegate" {
  account_id        = var.delegated_admin_account_id
  service_principal = "account.amazonaws.com"
  depends_on        = [aws_organizations_organization_service_access_status.account_management]
}

data "aws_organizations_organization" "existing" {
  count = var.already_exists ? 1 : 0
}
