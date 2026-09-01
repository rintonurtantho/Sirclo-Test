# Fetch Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "sirclo-vm-key"
  public_key = file(pathexpand(var.public_key_path))
}

# EC2 Instance Provisioning
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Free-tier eligible
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User Data script to automatically install Docker & Docker Compose on first boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y ca-certificates curl gnupg lsb-release
              
              # Install Docker
              sudo mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
              
              # Enable & start Docker service
              sudo systemctl enable docker
              sudo systemctl start docker
			  sudo usermod -aG docker ubuntu
              
              # 2. Clone Repositori dan Jalankan App
              # Ganti URL di bawah dengan URL repositori GitHub kamu
              git clone https://github.com/rintonurtantho/Sirclo-Test.git /home/ubuntu/app
              cd /home/ubuntu/app/app

              # Buat file .env dari .env.example
              cp .env.example .env

              # Jalankan Docker Compose
              sudo docker compose up -d
              EOF

  tags = {
    Name = "sirclo-wordpress-instance"
  }
}