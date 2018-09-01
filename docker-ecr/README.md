# packer-docker-ecr
A Packer template for [Docker](https://www.docker.com/) integrated with [AWS ECR credential helper](https://github.com/awslabs/amazon-ecr-credential-helper). This template bakes in the functionality to allow Docker to push/pull private images using Amazon's Elastic Container Registry.

## OS
The template is written for 64-bit RHEL-based systems that support the [systemd](https://www.freedesktop.org/wiki/Software/systemd/) init system.

## Template configuration
1. [config/docker-ecr.json](config/docker-ecr.json) - Contains sane defaults required during AMI creation. Note that the Docker version specified assumes the base AMI to be Amazon Linux 2.

Build the AMI using Packer

```
packer build -var-file=config/docker-ecr.json docker-ecr.json
```

## Working with ECR
Systemd is configured to run the Docker daemon on startup. `/root/.docker/config.json` is configured to use the ECR credential helper for interacting with ECR. This helper's binary is present at the path `/usr/bin/docker-credential-ecr-login`.

A private image can, for example, be fetched without any extra effort using the following command:

```
docker pull <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository>:<tag>
```

## IAM Permissions
The machine provisioned with this AMI must have the IAM permissions to interact with ECR. Based on the user's `docker push/pull` requirements, an appropriate set of permissions should be assigned. Please refer to [ECR managed policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr_managed_policies.html) for details on permissions for ECR.