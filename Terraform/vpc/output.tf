#security_groups

output "sg-Jenkins" {
  value = aws_security_group.terra-jenkins.id
}

output "sg-Docker" {
  value = aws_security_group.terra-docker.id
}

output "sg-k8s-master" {
  value = aws_security_group.terra-k8s-master.id
}

output "sg-k8s-worker" {
  value = aws_security_group.terra-k8s-worker.id
}

output "sg-rds" {
  value = aws_security_group.terra-rds.id
}

output "sg-alb" {
  value = aws_security_group.terra-alb.id
}

# subnet_ids

output "public_subnet_1" {
  value = aws_subnet.pub-sub-1.id
}

output "public_subnet_2" {
  value = aws_subnet.pub-sub-2.id
}

output "private_subnet_1" {
  value = aws_subnet.priv-sub-1.id
}

output "private_subnet_2" {
  value = aws_subnet.priv-sub-2.id
}

# vpc_id

output "vpc-id" {
  value = aws_vpc.terra-vpc.id
}