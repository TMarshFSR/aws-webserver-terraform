resource "aws_instance" "web-server-instance" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.av_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = var.net_id
  }

  tags = {
    Name = "web-server"
  }
}

resource "aws_db_instance" "sql-db" {
  identifier = "bae-db"
  allocated_storage    = 10
  db_subnet_group_name = var.subnet_group_name
  vpc_security_group_ids = [ var.sec_group_id_sql ]
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "aaaaaaaaaaaaa"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible   = false
}
