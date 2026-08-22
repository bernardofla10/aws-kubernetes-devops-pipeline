output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "private_subnet_ids" {
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}

output "public_subnet_ids_list" {
  value = [
    for az in sort(keys(aws_subnet.public)) :
    aws_subnet.public[az].id
  ]
}

output "private_subnet_ids_list" {
  value = [
    for az in sort(keys(aws_subnet.private)) :
    aws_subnet.private[az].id
  ]
}

output "nat_gateway_ids" {
  value = {
    for az, nat in aws_nat_gateway.this :
    az => nat.id
  }
}