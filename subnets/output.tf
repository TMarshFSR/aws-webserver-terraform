output "server_public_ip" {
    value = aws_eip.one.public_ip
}

output "net_id" {
    value = aws_network_interface.web-server-nic.id
}

output "nat_gate_id" {
    value = aws_nat_gateway.gw.id
}

output "subnet_group_name" {
    value = aws_db_subnet_group.private-group.name
  
}