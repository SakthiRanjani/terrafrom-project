output "sub1" {
  value = aws_subnet.sub1.id
}

output "sub2" {
  value = aws_subnet.sub2.id
}

output "sg" {
  value = aws_security_group.mysg.id
}

output "vpc" {
  value = aws_vpc.myvpc.id
}