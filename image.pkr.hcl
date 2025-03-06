
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
  default     = " "
}

variable "version" {
  type        = string
  default     = " "
  description = "AMI Release version"
}

variable "vpc_id" {
  type        = string
  description = "Main VPC created in the Network Infrastructure OU"
  default     = " "
}

locals {
  instance_type     = "t2.micro"
  region            = "us-east-1"
  ami_name          = "fictitious-app-ami"
  source_image_name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server*"
  source_ami_owners = ["099720109477"]
  ssh_username      = "ubuntu" 
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${local.ami_name}-${local.prefix}-${var.version}"
  instance_type = local.instance_type
  region        = local.region

  source_ami_filter {
    filters = {
      name                = local.source_image_name
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
  name = "${local.build_name}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "./"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline = [
      "echo creating app folder...",
      "sudo mkdir -p /opt/app",
      "sudo mv /tmp/* /opt/app/",
      "sudo chmod +x /opt/app/setup.sh"
    ]
  }

  provisioner "shell" {
    script = "setup.sh"
  }

  post-processor "amazon-ami-management" {
    regions       = [local.region]
    identifier    = local.ami_name
    keep_releases = 2
  }
}