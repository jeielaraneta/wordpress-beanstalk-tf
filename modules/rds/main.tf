data "aws_secretsmanager_secret" "secrets"{
  name = var.rds_secrets.id
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${var.db_prefix}-${var.env_name}-aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.db_prefix}-${var.env_name}-rds-cluster"
  availability_zones = var.availability_zones
  engine             = "aurora-mysql"
  engine_version     = "5.7.mysql_aurora.2.10.1"
  database_name      = "wordpress"
  master_username    = jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["username"]
  master_password    = jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)["password"]
  db_subnet_group_name = var.subnet_group_name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  
}