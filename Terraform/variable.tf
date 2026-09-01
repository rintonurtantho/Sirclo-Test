variable "aws_region" {
  type        = string
  default     = "ap-southeast-3"
  description = "Jakarta AWS region for deployment"
}

variable "public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the SSH public key for EC2 login"
}