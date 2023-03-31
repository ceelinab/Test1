terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.14.0"
    }
  }
}

provider "github" {
  owner = var.owner
  token = var.gh_token
}

data "github_repository" "test1" {
  full_name = "${var.owner}/${var.repository_name}"
}

resource "github_branch_protection" "example" {
  repository_id = data.github_repository.test1.id
  pattern       = "dev"

  required_status_checks {
    strict   = true
    contexts = ["ci"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = true
    required_approving_review_count = 2
  }

  require_signed_commits = true
}

resource "github_branch_protection" "dev" {
  repository_id = data.github_repository.test1.id
  pattern       = "prod"

  required_status_checks {
    strict   = true
    contexts = ["ci"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = true
    required_approving_review_count = 2
  }

  require_signed_commits = true
}