variable "project_id" {
  type = string
}

variable "github_owner" {
  type        = string
  description = "GitHub username or org"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo name only, no owner"
}