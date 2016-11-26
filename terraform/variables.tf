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
