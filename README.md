# eks-pipeline-project-bravo

Minimal monorepo for deploying a simple Node.js/Express app to Amazon EKS with GitHub Actions, Terraform, ECR, ingress-nginx, and cert-manager.

## Structure

- `app/`: Express application and Docker image build context
- `k8s/`: Kubernetes manifests for the workload and ingress
- `terraform/`: AWS infrastructure, EKS cluster, ECR, IAM, and cluster add-ons
- `.github/workflows/`: CI/CD pipeline for application deployment

## What Terraform Creates

- A new VPC with public and private subnets in `eu-central-1`
- A new EKS cluster named `eks-pipeline-project-bravo`
- An ECR repository named `eks-pipeline-project-bravo`
- A GitHub Actions OIDC provider and deployment IAM role
- `ingress-nginx` and `cert-manager` installed into the cluster

## Bootstrap Flow

Infrastructure is applied manually with Terraform from your machine.

```bash
cd terraform
terraform init
terraform apply
```

After the first apply:

1. Copy the AWS account ID into a GitHub repository variable named `AWS_ACCOUNT_ID`.
2. Push to `main` to let GitHub Actions build the Docker image, push it to ECR, and deploy it to EKS.
3. If you deployed an earlier version of this repo that used `external-dns`, run `terraform apply` once more with this simplified version so Terraform removes the old `external-dns` resources.

## DNS And TLS Flow

- `ingress-nginx` exposes the application through a cloud load balancer.
- `cert-manager` requests a Let's Encrypt certificate and stores it in the `alexanderkachar-com-tls` secret.
- You update the Route 53 record for `alexanderkachar.com` manually.

## Manual DNS Step

After the app is deployed, get the ingress load balancer hostname:

```bash
kubectl get ingress -n hello-app
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

Then update the Route 53 hosted zone for `alexanderkachar.com`:

1. Open Route 53 in AWS.
2. Open the hosted zone for `alexanderkachar.com`.
3. Edit the root domain records:
   - `A` record for `alexanderkachar.com`
   - `AAAA` record for `alexanderkachar.com` if you use one
4. Create Route 53 alias records that point to the current ingress load balancer created by `ingress-nginx`.
5. Wait a few minutes for DNS propagation.

You can verify that DNS is correct with:

```bash
kubectl get ingress -n hello-app -o wide
curl -I http://alexanderkachar.com
```

Once DNS points to the ingress, cert-manager should finish the HTTP-01 challenge and issue the TLS certificate.

## Notes

- The app is served from the root domain: `https://alexanderkachar.com`
- The deployment workflow tags Docker images with the Git commit SHA
- Infrastructure is intentionally manual so the setup stays easy to understand and repeat during training
