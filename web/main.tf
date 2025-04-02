data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "webserver1" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.sub1
  vpc_security_group_ids = [var.sg]
  user_data              = base64encode(file("userdata.sh"))
  tags = {
    Name = "WebServer1"
  }
}

resource "aws_instance" "webserver2" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.sub2
  vpc_security_group_ids = [var.sg]
  user_data              = base64encode(file("userdata.sh"))
  tags = {
    Name = "WebServer2"
  }
}

resource "aws_lb" "myalb" {
   name               = "myalb"
   internal           = false
   load_balancer_type = "application"
   security_groups    = [var.sg]
   subnets            = [var.sub1, var.sub2]

   tags = {
     Name = "Web"
   }
 }


 resource "aws_lb_target_group" "mytg" {
   name     = "TargetGroup"
   port     = 80
   protocol = "HTTP"
   vpc_id   = var.vpc

   health_check {
     path = "/"
     port = "traffic-port"
   }

 }

resource "aws_lb_target_group_attachment" "attach1" {
   target_group_arn = aws_lb_target_group.mytg.arn
   target_id        = aws_instance.webserver1.id
   port             = 80
 }


 resource "aws_lb_target_group_attachment" "attach2" {
   target_group_arn = aws_lb_target_group.mytg.arn
   target_id        = aws_instance.webserver2.id
   port             = 80
 }

 resource "aws_lb_listener" "listener" {
   load_balancer_arn = aws_lb.myalb.arn
   port              = 80
   protocol          = "HTTP"

   default_action {
     target_group_arn = aws_lb_target_group.mytg.arn
     type             = "forward"
   }
 }

