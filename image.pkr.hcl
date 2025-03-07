packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    amazon-ami-management = {
      version = ">= 1.0.0"
      source  = "github.com/wata727/amazon-ami-management"
    }
  }
}

variable "subnet_id" {
  type        = string
  description = "Development Account OU Public Subnet ID shared by RAM"
  default     = ""  # Use an empty string or provide a default value
}

variable "version" {
  type        = string
  default     = ""  # Use an empty string or provide a default value
  description = "AMI Release version"
}

variable "vpc_id" {
  type        = string
  description = "Main VPC created in the Network Infrastructure OU"
  default     = ""  # Use an empty string or provide a default value
}

locals {
  ami_name          = "fictitious-app-ami"
  source_image_name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server*"
  source_ami_owners = ["099720109477"]
  ssh_username      = "ubuntu"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${local.ami_name}-${var.version}"
  instance_type = "t2.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name                = local.source_image_name  # Corrected variable name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = local.source_ami_owners
  }

  ssh_username                = local.ssh_username
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
}

build {
  name = "custom_ami"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "./"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline = [
      "echo Moving files...",
      "sudo mkdir -p /opt/app",
      "sudo mv /tmp/* /opt/app",
      "sudo chmod +x /opt/app/setup.sh"
    ]
  }

  provisioner "shell" {
    script = "setup.sh"
  }

  post-processor "amazon-ami-management" {
    regions       = ["us-east-1"]  # Consistent with the source region
    identifier    = local.ami_name
    keep_releases = 2
  }
}