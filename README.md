# Oracle Cloud Terraform Guide

## Background
The **FREE** ARM instance included in the Oracle Cloud Infrastructure's (OCI) Always Free tier is amazing. However, the resource are limited and you will most likely encounter the "Out of Capacity" error when you try to create the ARM compute instance. The only solution to this is keep on trying until success, it is just a matter of time until you get your machine.
  
**This Repo is a super easy guide to automate the Cloud Instance creation process using Terraform.**
  

## Setup
There are two methods to use Terraform, either directly use their binary or run with Docker container.
- Obtain the binary from https://www.terraform.io/downloads

  OR

- Build the Docker container following the below guide

### Build the Docker container
For x86 machine:
```bash
docker build -f Dockerfile.amd64 -t terrform .
```
From ARM machine:
```bash
docker build -f Dockerfile.aarch64 -t terrform .
```
## Prepare Your Oracle Cloud Info
1. We need to collect the info listed in login.env
```
TF_VAR_tenancy_ocid=
TF_VAR_user_ocid=
TF_VAR_fingerprint=
TF_VAR_private_key_path=/config/key.pem
TF_VAR_region=
```

Please refer to the guide from Oracle: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm

Remember to save the key file under the config folder

2. Obtain the Terraform Config file for the desired cloud instance
    1. Go to the "Create compute instance" page
    2. Complete the selection
    3. Click on "Save as Stack" insted of "Create"
    4. In the 'Create Stack" page, just keep on clicking "Next" and finally "Create"
    5. After being redirected to the "Stack Detail" page, click on the "Download" button beside "Terraform Configuration"
    6. Unzip and save the main.tf under the config folder
    7. Open main.tf and replace 
```
provider "oci" {}
```

with
```
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
```
    

## Run

### Using binary
#### Linux
```bash
#Export all the env in login.env
export TF_VAR_tenancy_ocid=<tenancy_OCID>
export TF_VAR_user_ocid=<user_OCID>
export TF_VAR_fingerprint=<key_fingerprint>
export TF_VAR_private_key_path=<private_key_path>
export TF_VAR_region=<region>

cd path/to/config
terraform init
terraform apply -auto-approve
#Or use a auto loop script
bash config/loop.sh
```

#### Windows
```bash
#Export all the env in login.env
setx TF_VAR_tenancy_ocid <tenancy_OCID>
setx TF_VAR_user_ocid <user_OCID>
setx TF_VAR_fingerprint <key_fingerprint>
setx TF_VAR_private_key_path <private_key_path>
setx TF_VAR_region=<region>

cd path/to/config
terraform init
terraform apply -auto-approve
#Or use a auto loop script
bash config/loop.sh
```

### Using Docker
```bash
docker run -it --rm --env-file login.env -v path/to/config/folder:/config terrform /bin/bash
terraform init
bash loop.sh
```
**Remember to change the path according to your env**
