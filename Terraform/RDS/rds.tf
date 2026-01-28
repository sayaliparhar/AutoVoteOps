resource "aws_db_subnet_group" "db_subnet_group" {
  name = "private-subnet-groups"
  subnet_ids = [ var.private_sub_1, var.private_sub_2 ]
}

resource "aws_db_instance" "rds_db" {
  db_name = "Voting"
  engine = "mysql"
  engine_version = "8.0"
  multi_az = false
  username = "root"
  password = "sayaliparhar"
  instance_class = "db.t3.micro"
  storage_type = "gp3"
  allocated_storage = 400
  port = 3306
  network_type = "IPV4"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible = false
  vpc_security_group_ids = [var.rds_sg]
  skip_final_snapshot = true
  deletion_protection = false
}