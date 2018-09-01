# packer-templates
This repository contains some useful, yet minimal [Packer](https://www.packer.io/) templates. They most likeley need to be extended by the user based on specific infrastructure requirements. The idea is to provide templates that solve common installation and setup problems for a large number of use cases.

## Project Structure
```
.
├── LICENSE
├── README.md
│
├── <template-1>                          # Root directory of the template
│   ├── README.md                         # Documentation of the template
│   ├── <template-1>.json                 # Main template file supplied to "packer build"
│   ├── config                            # Directory containing configurations for the template required at build time
│   │   └── <template-1>.json
│   │   └── ...
│   └── src                               # Installation and setup instructions to be executed
│       ├── assets                        # Assets that need to be placed on the machine, like configuration files or init scripts
│       │   └── docker-config.json
│       │   └── ...
│       ├── <template-1>.sh               # Entrypoint script for the current template
│       └── ...
│
├── <template-2>
│   └── ...
└── ...
```

## Platform Compatibility
All templates are built using the [Amazon EBS builder](https://www.packer.io/docs/builders/amazon-ebs.html) and are designed to work with 64-bit Amazon Linux and RHEL systems, unless stated otherwise. Making them compatible with other Operating systems or cloud providers would most likely require the user to make changes specific to their use case.

Note that some configuration parameters have intentionally been omitted from all templates. These should be provided at validation or build time by the user. For example, if Packer is running locally, it must be provided credentials for the builder(s) if required.