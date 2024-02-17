/*
    This file is responsible for creating the RDS instance and running the initial setup script.
    The initial setup script is located in the data/rds/setup directory.
    The script is run using the null_resource provisioner.
    
    ON STANDBY untill lambda is ready

resource "aws_db_instance" "custom-cloudwatch-database" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  availability_zone    = "eu-central-1a"
}

data "local_file" "data_setup_script" {
  filename = "${path.module}/data/rds/setup/rds_initial_setup.sql"
}

resource "null_resource" "db_setup" {
  depends_on = [module.db, aws_security_group.rds_main, aws_default_security_group.default]
  provisioner "local-exec" {
    command = "mysql --host=${module.db.this_db_instance_address} --port=${var.rds-database.port} --user=${var.rds-database.user} --password=${var.rds-database.password} < ${data.local_file.data_setup_script.content}"
  }
}

*/