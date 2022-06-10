# This is to output some useful data so you don't have to go trolling through the UI

output "dns_name" {
    value = aws_lb.http.dns_name
}

output "ec2_ips" {
    value = aws_instance.example.*.public_ip
}