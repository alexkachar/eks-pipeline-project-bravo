# eks-pipeline-project-bravo

Minimal monorepo for deploying a simple Node.js/Express app to Amazon EKS with GitHub Actions, Terraform, ECR, ingress-nginx, cert-manager, and external-dns.

## Structure

- `app/`: Express application and Docker image build context
- `k8s/`: Kubernetes manifests for the workload and ingress
- `terraform/`: AWS infrastructure, EKS cluster, ECR, IAM, and cluster add-ons
- `.github/workflows/`: CI/CD pipelines for infrastructure and application deployment

## What Terraform Creates

- A new VPC with public and private subnets in `eu-central-1`
- A new EKS cluster named `eks-pipeline-project-bravo`
- An ECR repository named `eks-pipeline-project-bravo`
- A GitHub Actions OIDC provider and deployment IAM role
- `ingress-nginx`, `cert-manager`, and `external-dns` installed into the cluster
- Route 53 permissions for `external-dns` to manage `alexanderkachar.com`

## Bootstrap Flow

The first infrastructure apply must be run with AWS credentials outside GitHub Actions, because the GitHub OIDC role is created by Terraform during that initial apply.

```bash
cd terraform
terraform init
terraform apply
```

After the first apply:

1. Copy the AWS account ID into a GitHub repository variable named `AWS_ACCOUNT_ID`.
2. Push to `main` to let GitHub Actions build the Docker image, push it to ECR, and deploy it to EKS.
3. Use the `Terraform Infra` workflow for validation and planning, or add a remote Terraform backend before enabling automated applies from GitHub Actions.

## DNS And TLS Flow

- `ingress-nginx` exposes the application through a cloud load balancer.
- `external-dns` creates and maintains the `alexanderkachar.com` Route 53 record.
- `cert-manager` requests a Let's Encrypt certificate and stores it in the `alexanderkachar-com-tls` secret.

## Notes

- The app is served from the root domain: `https://alexanderkachar.com`
- The deployment workflow tags Docker images with the Git commit SHA
- The Terraform workflow intentionally stops at `terraform plan`; local state is not safe for unattended GitHub Actions applies
- Add a remote backend before turning infrastructure changes into a fully automated GitHub Actions apply pipeline
