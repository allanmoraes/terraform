data "aws_caller_identity" "current" {}

locals {
    environment = var.environment == null ? terraform.workspace : var.environment

    local_tags = {
        "env"         = lower(local.environment)
        "owner-team"  = lower(replace(var.owner_team, "_", "-"))
        "managed-by"  = lower(replace(var.managed_by, "_", "-"))
        "cost-center" = lower(replace(var.cost_center, "_", "-"))
        "repository"  = lower(var.repository)
        "deployed_by" = data.aws_caller_identity.current.arn
    }

    tags = local.local_tags

    all_tags = { for a, i in local.tags : a => lower(i) }
}