module "labels" {
    source      = "../modules/labels"
    owner_team  = var.owner_team
    cost_center = var.cost_center
    repository  = var.repository
}