resource "aws_instance" "demo_instance" {
  ami = "ami-0c42696027a8ede58"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tomcat_security_group.id]

  tags = {
    name = "demo_assignment"
  }
   user_data = <<-EOF
              yum -y update
              yum -y install tomcat
              systemctl start tomcat
              systemctl enable tomcat
              
              cp ./index.html /usr/share/tomcat/webapps/ROOT/index.html
              EOF
}

resource "aws_security_group" "tomcat_security_group" {
  name        = "tomcat-security-group"
  description = "Security group for Apache Tomcat"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.134.109/32"] 
  }
}
output "instance_public_ip" {
  value = aws_instance.demo_instance.public_ip
}