data "aws_availability_zones" "available" {}

data "template_file" "app-cloud-init" {
  template = "${file("app_cloud-config.tpl")}"

  vars {
    role = "app"
  }

}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  public_key = "${file(var.sshpubkey_file)}"
}


resource "aws_elb" "pfae_app_elb" {
  name = "pfae-app-elb"

  subnets = ["${aws_subnet.app_subnet.id}"]
  security_groups  = ["${aws_security_group.pfae_elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_autoscaling_group" "pfae_app" {
  vpc_zone_identifier  = ["${aws_subnet.app_subnet.id}"]
  max_size             = "5"
  min_size             = "${var.app_instance_count}"
  desired_capacity     = "${var.app_instance_count}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.pfae_app.name}"
  load_balancers       = ["${aws_elb.pfae_app_elb.name}"]

  tag {
    key                 = "Name"
    value               = "pfae_app"
    propagate_at_launch = "true"
  }
  tag {
    key                 = "project"
    value               = "pfae"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "pfae_app" {
  image_id      = "${var.ami_id}"
  instance_type = "${var.instance_type}"

  security_groups =["${aws_security_group.pfae_app.id}"]
  user_data       = "${data.template_file.app-cloud-init.rendered}"
  key_name        = "${aws_key_pair.auth.id}"
}

module "pfae_sql_db" {
  source = "modules/pfae_instance"
  ami_id = "${var.ami_id}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.pfae_sql_db.id}"]
  instance_count = "2"
  instance_type = "${var.instance_type}"
  tags = {
    role = "sql",
  }
  subnet_id = "${aws_subnet.sql_db_subnet.id}"
}

module "pfae_nosql_db" {
  source = "modules/pfae_instance"
  ami_id = "${var.ami_id}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.pfae_nosql_db.id}"]
  instance_count = "3"
  instance_type = "${var.instance_type}"
  tags = {
    role = "nosql",
  }
  subnet_id = "${aws_subnet.nosql_db_subnet.id}"
}

module "pfae_jumphost" {
  source = "modules/pfae_instance"
  ami_id = "${var.ami_id}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.pfae_jumphost.id}"]
  instance_count = "1"
  instance_type = "${var.instance_type}"
  tags = {
    role = "jumphost",
  }
  subnet_id = "${aws_subnet.jumphost_subnet.id}"
}
