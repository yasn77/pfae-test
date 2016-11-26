# PFAE Terraform
It is highly recommended that you use [direnv](http://direnv.net/). A `.envrc` exists that facilitates in setting up virtualenv and source enviroment variables used by both Terraform and Ansible.

The following environment variables are required to be set:

|Environment Variable|Description|
|--------------------|-----------|
|`AWS_SECRET_ACCESS_KEY`|AWS Secret Access Key|
|`AWS_ACCESS_KEY_ID`|AWS Access Key ID|
|`TF_VAR_access_key`|Set same as `AWS_ACCESS_KEY_ID`|
|`TF_VAR_secret_key`|Set Same as `AWS_ACCESS_KEY_ID`|
|`TF_VAR_sshpubkey_file`|Path to SSH private key (will be used to SSH in to EC2 Instances)|

If you use `direnv`, then these can be stored in `<REPO_ROOT>/.secrets` and will automatically be loaded and exported.

You will need to install [Terraform](https://www.terraform.io/). Installation instructions can be found on the [Terraform website](https://www.terraform.io/intro/getting-started/install.html). The code has been tested with Terraform version `v0.7.5`, however it should work fine with newer versions.

Below are the default variables (which can all be overriden using [environment variables](https://www.terraform.io/docs/configuration/environment-variables.html)):
```
variable "access_key" {}
variable "secret_key" {}
variable "sshpubkey_file" {
  default = "sshpub.key"
}
variable "region" {
  default = "eu-west-1"
}
variable "ami_id" {
  default = "ami-0d77397e"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "app_instance_count" {
  default = "1"
}
variable "cidr_block" {
  default = "10.10.0.0/16"
}
variable "app_subnet_id" {
  default = "10.10.19.0/24"
}

variable "sql_db_subnet_id" {
  default = "10.10.20.0/24"
}

variable "nosql_db_subnet_id" {
  default = "10.10.21.0/24"
}

variable "jumphost_subnet_id" {
  default = "10.10.22.0/24"
}
```

To launch Terraform:
```shell
terraform plan
terraform apply
```

To destroy the platform:
```shell
terraform destroy
```
_note: This assumes you are using `direnv`, if not you will need to set the environment variables_

To view the external hostname for the AWS jumphost run:
```shell
terraform output jumphost_dns_list
```

To view the ELB hostname (so you can browse the site), run:
```shell
terraform output elb_dns_name
```
