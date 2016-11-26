data "template_file" "cloud-init" {
  template = "${file("${path.module}/${var.tags["role"]}_cloud-config.tpl")}"

  vars {
    role = "${var.tags["role"]}"
  }

}

resource "aws_instance" "pfae" {
  connection {
    user = "ubuntu"
  }
  count = "${var.instance_count}"
  subnet_id = "${var.subnet_id}"
  user_data = "${data.template_file.cloud-init.rendered}"
  instance_type = "${var.instance_type}"
  ami = "${var.ami_id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  tags = "${merge(map("project", "pfae"), var.tags)}"
}
