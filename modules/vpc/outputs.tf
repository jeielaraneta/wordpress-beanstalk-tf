output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "rds_subnet_group" {
    value = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_security_group_id" {
    value = aws_security_group.rds_secgroup.id
}

output "public_subnets" {
    value = local.public_subnets
}

output "private_subnets" {
    value = local.private_subnets
}
output "database_subnets" {
    value = local.dabase_subnets
}