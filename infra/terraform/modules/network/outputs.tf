output "vpc_id" {
  value       = aws_vpc.media.id
  description = "ID of the media VPC"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "IDs of public subnets"
}
