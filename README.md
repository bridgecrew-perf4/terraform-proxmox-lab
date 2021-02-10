# Simple Terraform template for spawning VMs in one of my local Proxmox servers

This is to be used as a basis for future projects that will involve IaC.

## Quick Start

Create a secret.tfvars file that contains the 'proxmox_username' and 'proxmox_password' variables and their values

Initialize terraform in the directory
```
terraform init
```

Format and validate the config
```
terraform fmt
terraform validate
```

Plan out the changes that will be made, if necessary
```
terraform plan
```

Apply the configuration and create the vms on proxmox server
```
terraform apply
```