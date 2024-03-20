/*
    This file is responsible for creating the RDS instance and running the initial setup script.
    The initial setup script is located in the data/rds/setup directory.
    The script is run using the null_resource provisioner.
    
    ON STANDBY untill lambda is ready
*/

resource "aws_db_instance" "custom_cloudwatch_database" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.custom_cloudwatch_database.username
  password             = var.custom_cloudwatch_database.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
}