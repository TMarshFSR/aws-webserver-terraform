resource "aws_subnet" "subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

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
    Name = "public-subnet"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_db_subnet_group" "private-group" {
  name       = "private-group"
  subnet_ids = [aws_subnet.subnet-2.id, aws_subnet.subnet-3.id]

  tags = {
    Name = "My DB subnet group"
  }
}



resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = var.route_id_prod
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = var.route_id_private
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = var.route_id_private
}



resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = var.net_private_ips
  security_groups = [var.sec_group_id]
}

resource "aws_eip" "one" {
  vpc        = true
  depends_on = [var.internet_gate]
}

resource "aws_nat_gateway" "gw" {

  allocation_id = aws_eip.one.id
  subnet_id     = aws_subnet.subnet-1.id
}

