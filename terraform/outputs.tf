output "aws_region" {
  value = var.aws_region
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "route53_zone_id" {
  value = data.aws_route53_zone.primary.zone_id
}

output "letsencrypt_email" {
  value = var.letsencrypt_email
}

