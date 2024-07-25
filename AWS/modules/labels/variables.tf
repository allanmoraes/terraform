variable "owner_team" {
    description = "Responsible team"
    type        = string
    default     = null
}

variable "managed_by" {
    description = "Which tools manages the rosource"
    type        = string
    default     = "terraform"

    validation {
        condition     = can(regex("^terraform$", var.managed_by))
        error_message = "The value shouled be 'terraform' since this is written in terraform"
    }
}

variable "cost_center" {
    description = "Resource's Cost Center"
    type        = string
    default     = null
}

variable "environment" {
    description = "Workspace value"
    type        = string
    default     = null
}

variable "repository" {
    description = "Repository value"
    type        = string
    default     = null
}