output "id_list" {
  value = ["${aws_instance.pfae.*.id}"]
}

output "dns_list" {
  value = ["${aws_instance.pfae.*.public_dns}"]
}

