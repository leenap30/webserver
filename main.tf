provider "aws"{
region = "us-east-2"
}

resource "aws_instance" "web" {
  ami           =  "ami-0d5eff06f840b45e9"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data         = <<EOF
#!/bin/sh
yum -y update
yum -y install httpd
echo "<h2>Built by Terraform</h2>" /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF

  tags = {
    Name = "Webserver Built by Terraform"
  }
}

resource "aws_security_group" "web" {
  name        = "webserver-SG"
  description = "Security group for webserver"

 ingress {
    description      = "for webserver"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "for webserver"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "for webserver"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
      }

  tags = {
    Name = "Webserver sg by Terraform"
  }
}
