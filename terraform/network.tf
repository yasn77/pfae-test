resource "aws_vpc" "pfae" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  tags {
        Name = "pfae_vpc"
  }
}

resource "aws_internet_gateway" "pfae" {
  vpc_id = "${aws_vpc.pfae.id}"
  tags {
        Name = "pfase_gw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.pfae.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.pfae.id}"
}

resource "aws_subnet" "app_subnet" {
  vpc_id                  = "${aws_vpc.pfae.id}"
  cidr_block              = "${var.app_subnet_id}"
  map_public_ip_on_launch = true
  tags {
        Name = "app_subnet"
  }
}

resource "aws_subnet" "sql_db_subnet" {
  vpc_id                  = "${aws_vpc.pfae.id}"
  cidr_block              = "${var.sql_db_subnet_id}"
  map_public_ip_on_launch = true
  tags {
        Name = "sql_db_subnet"
  }
}

resource "aws_subnet" "nosql_db_subnet" {
  vpc_id                  = "${aws_vpc.pfae.id}"
  cidr_block              = "${var.nosql_db_subnet_id}"
  map_public_ip_on_launch = true
  tags {
        Name = "nosql_db_subnet"
  }
}

resource "aws_subnet" "jumphost_subnet" {
  vpc_id                  = "${aws_vpc.pfae.id}"
  cidr_block              = "${var.jumphost_subnet_id}"
  map_public_ip_on_launch = true
  tags {
        Name = "jumphost_subnet"
  }
}
