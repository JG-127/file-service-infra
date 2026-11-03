provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = var.student_id
      Team        = var.team_number
      Environment = var.environment
      Project     = "file-service"
      ManagedBy   = "terraform"
    }
  }
}
