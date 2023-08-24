terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


###############################################################################
### djl-win-server
###############################################################################
resource "aws_instance" "djl-win-server" {
  ami           = "ami-0e2c8caa770b20b08" # us-east-1
  instance_type = "t3.large"
  subnet_id                   = "subnet-069a69e50bd1ebb23"
  #availability_zone           = "us-east-1"
  associate_public_ip_address = "false"
  key_name                    = "DemoVPC_Key_Pair"
  vpc_security_group_ids      = ["sg-0bdd2047a7484de2f"]

  tags = {
    Name = "djl-win-server"
  }
}
###############################################################################


###############################################################################
### djl-database-1
###############################################################################
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "tf_db_group"
  subnet_ids = ["subnet-069a69e50bd1ebb23", "subnet-0871b35cbe9d0c1cf", "subnet-045bd90a8091ea930"]
}

resource "aws_db_instance" "mysqlrds" {
  allocated_storage    = 10
  storage_encrypted    = true
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  publicly_accessible  = false
  identifier           = "djl-database-1"
  name                 = "djl"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = ["sg-091fff29ba7c79318"]
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.id
  multi_az = false
  #backup_retention_period = 35
  skip_final_snapshot  = true
  tags = {Name = "djl-database-1", phidb = true, s3export = true, storagetier = "s3glacier"}
  copy_tags_to_snapshot = true
}
###############################################################################


###############################################################################
### djl-database-2
###############################################################################

###############################################################################
