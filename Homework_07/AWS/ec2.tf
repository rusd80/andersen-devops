
resource "aws_lb" "web" {
  name = "myALB"
  load_balancer_type = "application"
  subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  security_groups = [aws_security_group.elb.id]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name_prefix = "task-"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
}


resource "aws_iam_instance_profile" "instprof" {
  name = "${var.prefix}-instprof"
  role = aws_iam_role.role_ec2_s3.name
}


resource "aws_launch_configuration" "web" {
  name_prefix     = "${var.prefix}LC_"
  image_id        = "ami-05d34d340fb1d89e5"
  instance_type   = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instprof.id
  security_groups = [aws_security_group.web.id]

  key_name  = aws_key_pair.generated_key.key_name
  user_data = file("script.sh")

  lifecycle {
    create_before_destroy = true
  }
}

# autoscaling group of ec2's
resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  target_group_arns    = [aws_lb_target_group.web.arn]


  lifecycle {
    create_before_destroy = true
  }
}

