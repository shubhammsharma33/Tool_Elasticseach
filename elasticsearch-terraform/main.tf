provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = "192.168.0.0/16"
  public_subnets = ["192.168.10.0/24", "192.168.20.0/24"]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

# --------------------First Ubuntu Instance --------------------
module "ubuntu_instance_1" {
  source           = "./modules/instances"
  ami_id           = "ami-0d016af584f4febe3" # Ubuntu 22.04
  instance_type    = "t2.medium"
  key_name         = "new-key"
  public_subnet_id = module.networking.public_subnet_ids[0]
  public_sg_id     = module.security.public_sg_id
  name             = "elasticsearch-server0"
}

# --------------------Second Ubuntu Instance --------------------
module "ubuntu_instance_2" {
  source           = "./modules/instances"
  ami_id           = "ami-0d016af584f4febe3" # Ubuntu 22.04
  instance_type    = "t2.medium"
  key_name         = "new-key"
  public_subnet_id = module.networking.public_subnet_ids[1]
  public_sg_id     = module.security.public_sg_id
  name             = "elasticsearch-server1"
}

# -------------------- S3 Backend --------------------
module "s3_backend" {
  source      = "./modules/backend-s3"
  bucket_name = var.bucket_name
}

# -------------------- Outputs --------------------
output "ubuntu_public_ip_1" {
  value = module.ubuntu_instance_1.public_instance_ip
}

output "ubuntu_public_ip_2" {
  value = module.ubuntu_instance_2.public_instance_ip
}

output "ubuntu_fetch_name_1" {
  value = module.ubuntu_instance_1.fetch_name
}

output "ubuntu_fetch_name_2" {
  value = module.ubuntu_instance_2.fetch_name
}
