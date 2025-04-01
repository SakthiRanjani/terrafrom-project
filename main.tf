#root module

module "vpc" {
  source = "./vpc"
}

module "my_ec2" {
  source = "./web"
  sub1 = module.vpc.sub1
  sub2 = module.vpc.sub2
  sg = module.vpc.sg
  vpc = module.vpc.vpc
}

# resource "aws_vpc" "myvpc" {
#   cidr_block = var.cidr
#   tags = {
#     Name = "TerraformVPC"
#   }
# }
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id
# }

# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }
# resource "aws_route_table_association" "rta1" {
#   subnet_id      = aws_subnet.sub1.id
#   route_table_id = aws_route_table.rt.id
# }

# resource "aws_route_table_association" "rta2" {
#   subnet_id      = aws_subnet.sub2.id
#   route_table_id = aws_route_table.rt.id
# }

# resource "aws_subnet" "sub1" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.0.0.0/24"
#   availability_zone       = "eu-central-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "PublicSubnet1"
#   }
# }

# resource "aws_subnet" "sub2" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "eu-central-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "PublicSubnet2"
#   }
# }




# resource "aws_security_group" "mysg" {
#   name_prefix = "web-sg"
#   vpc_id      = aws_vpc.myvpc.id
#   ingress {
#     description = "Http"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "WebSg"
#   }
# }

# resource "aws_s3_bucket" "example" {
#   bucket = "terraformprojectsakthi"

#   tags = {
#     Name = "My terraform bucket"
#   }
# }

# data "aws_ami" "latest_amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# resource "aws_instance" "webserver1" {
#   ami                    = data.aws_ami.latest_amazon_linux.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.sub1.id
#   vpc_security_group_ids = [aws_security_group.mysg.id]
#   user_data              = base64encode(file("userdata.sh"))
#   tags = {
#     Name = "WebServer1"
#   }
# }

# resource "aws_instance" "webserver2" {
#   ami                    = data.aws_ami.latest_amazon_linux.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.sub2.id
#   vpc_security_group_ids = [aws_security_group.mysg.id]
#   user_data              = base64encode(file("userdata.sh"))
#   tags = {
#     Name = "WebServer2"
#   }
# }

# resource "aws_lb" "myalb" {
#   name               = "myalb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.mysg.id]
#   subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

#   tags = {
#     Name = "Web"
#   }
# }


# resource "aws_lb_target_group" "mytg" {
#   name     = "TargetGroup"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.myvpc.id

#   health_check {
#     path = "/"
#     port = "traffic-port"
#   }

# }

# resource "aws_lb_target_group_attachment" "attach1" {
#   target_group_arn = aws_lb_target_group.mytg.arn
#   target_id        = aws_instance.webserver1.id
#   port             = 80
# }


# resource "aws_lb_target_group_attachment" "attach2" {
#   target_group_arn = aws_lb_target_group.mytg.arn
#   target_id        = aws_instance.webserver2.id
#   port             = 80
# }

# resource "aws_lb_listener" "listener" {
#   load_balancer_arn = aws_lb.myalb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.mytg.arn
#     type             = "forward"
#   }
# }

# output "loadbalancerdns" {
#   value = aws_lb.myalb.dns_name
# }