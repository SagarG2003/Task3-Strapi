provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "strapi" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Update the package index
              yum update -y

              # Install Docker
              amazon-linux-extras install docker -y

              # Start Docker service
              service docker start

              # Add the ec2-user to the docker group so you can execute Docker commands without using sudo
              usermod -a -G docker ec2-user

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Pull the Strapi and MySQL Docker images
              docker-compose -f /srv/app/docker-compose.yml up -d
              EOF

  tags = {
    Name = "StrapiInstance"
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/srv/app/docker-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "/srv/app/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose -f /srv/app/docker-compose.yml up -d"
    ]
  }
}

output "instance_ip" {
  value = aws_instance.strapi.public_ip
}
