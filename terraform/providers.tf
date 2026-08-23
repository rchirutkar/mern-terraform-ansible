provider "aws" {
  region  = var.aws_region
  profile = "terraform-user"

  default_tags {
    tags = {
      Project     = "TravelMemory"
      Environment = "Assignment"
      ManagedBy   = "Terraform"
      Owner       = "rchirutkar"
    }
  }
}