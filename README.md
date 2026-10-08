# terraform-ec2

Terraform repository that provisions a single EC2 instance in us-east-1 and associated network infrastructure.

## Prerequisites

- `terraform-s3-bucket` repo deployed first.
- The shared S3 bucket stores Terraform state and EC2 metadata.
- GitHub secrets:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_ACCOUNT_ID
  - AWS_DEFAULT_REGION

## Architecture

```
[GitHub Actions]
      |
[Terraform Apply] --> [VPC, Subnet, IGW, SG, KeyPair, EC2]
      |
[S3 Bucket: terraform-infra-metadata-<AWS_ACCOUNT_ID>]
  |-- terraform-state/ec2/terraform.tfstate
  |-- ec2/<instance-id>.json
  |-- ec2/latest.json
```

## How to use

### Apply
Push to `main` to trigger `plan-apply.yml`. 
After apply, the EC2 instance runs and metadata is updated in the S3 bucket.
The `ec2-key.pem` is returned as a workflow artifact (1-day retention). Download it.

### Fetch EC2 Details
```bash
aws s3 cp s3://terraform-infra-metadata-<AWS_ACCOUNT_ID>/ec2/latest.json - | jq .
```

### SSH
```bash
chmod 400 ec2-key.pem
ssh -i ec2-key.pem ec2-user@<public_ip>
```

### Destroy
Use the GitHub Actions "Destroy" workflow, providing "DESTROY" as input.
*Security Warning:* Port 22 is open to `0.0.0.0/0`. Restrict this for production environments.
