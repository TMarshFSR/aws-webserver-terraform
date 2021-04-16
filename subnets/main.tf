resource "aws_subnet" "subnet-1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = var.route_id
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = var.net_private_ips
  security_groups = [var.sec_group_id]
}

resource "aws_eip" "Nat-Gateway-EIP" {
  vpc                       = true
  depends_on                = [var.internet_gate]
}

resource "aws_nat_gateway" "gw" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  subnet_id     = aws_subnet.subnet-1.id
  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "NAT_gateway_RT" {
  depends_on = [
    aws_nat_gateway.gw
  ]
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = {
    Name = "Route table for gateway"
  }
}
