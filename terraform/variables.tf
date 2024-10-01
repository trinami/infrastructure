variable "hcloud_token" {
  sensitive = true
  default   = ""
}

variable "org" {
  default = "trinami.org"
}

variable "zip" {
  default = "trinami.zip"
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
  default     = ""
}
