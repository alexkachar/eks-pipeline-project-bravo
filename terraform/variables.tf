variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used as the prefix for AWS resources."
  type        = string
  default     = "eks-pipeline-project-bravo"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "eks-pipeline-project-bravo"
}

variable "root_domain" {
  description = "Primary domain that will route traffic to the app."
  type        = string
  default     = "alexanderkachar.com"
}

variable "github_repository" {
  description = "GitHub repository slug allowed to assume the OIDC deployment role."
  type        = string
  default     = "alexkachar/eks-pipeline-project-bravo"
}

variable "letsencrypt_email" {
  description = "Email address used by cert-manager for Let's Encrypt."
  type        = string
  default     = "alexkachar.github@gmail.com"
}

