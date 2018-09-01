# packer-atlantis
A Packer template for [Atlantis](https://www.runatlantis.io/) - the Terraform workflow automation tool.

## Template configuration
1. [config/atlantis.json](config/atlantis.json) - Contains sane defaults required during AMI creation.

Build the AMI using Packer

```
packer build -var-file=config/atlantis.json atlantis.json
```

By default, the template creates both the builder and the AMI in `us-east-1` (N. Virginia).

## Running Atlantis
This template only creates a base AMI with the required dependencies installed. It is recommended that you extend it to include an [Upstart](http://upstart.ubuntu.com/cookbook/) or [systemd](https://www.freedesktop.org/wiki/Software/systemd/) configuration which is responsible for fetching necessary runtime information and launching `atlantis` with it.

`atlantis` itself resides under `/usr/bin`. Its assets reside under `/opt/atlantis`:

1. `/opt/atlantis/config.yaml` - Contains minimal configuration for Atlantis server. Some values need to be set by the user before running atlantis, either at AMI creation time or at runtime. Besides the configuration present in `config.yaml`, you will also need to supply the user and token information of the version control platform you're using at the very least.
2. `/opt/atlantis/data` - Directory for atlantis to store its data. This AMI does not handle backing up of this directory. It must be handled by the user.

Atlantis must be run using `atlantis server --config /opt/atlantis/config.yaml`.

## Recommendations

### SSL
For obvious reasons, all communication with atlantis must take place over HTTPS. Atlantis allows you to provide SSL certificate for your domain. It is highly recommended that you either provide the certificate and key directly to Atlantis server or run it behind a load balancer that manages SSL for you.

### Assume an IAM role to "terraform apply"
An EC2 machine that uses Terraform to manage your infrastructure requires a large set of extremely sensitive permissions. A common practice is to assign these permissions to the default IAM role of the machine. The problem with this approach is that if anyone logged into the machine accidently makes any sort of request to AWS, it will most likely go through. The consequences of this are left up to the reader's imagination.

Instead, the recommended way for servers requiring such sensitive permissions is for them to [Assume another IAM role](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html) temporarily, perform the required tasks, then give up the role. This other role the server temporarily takes on contains all the sensitive permissions Terraform requires.

### Fetch secrets at runtime
Secrets such as Github token or webhook secret must not be hard-coded or present at AMI creation time. This compromises security and also hinders our ability to rotate them. Instead, they should be fetched at runtime prior to launching atlantis server from a secret storage engine such as AWS Secrets Manager or Vault.

See Atlantis [Installation guide](https://www.runatlantis.io/docs/deployment.html).