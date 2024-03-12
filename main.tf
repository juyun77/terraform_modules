# module "eks" {
#   # eks 모듈에서 사용할 변수 정의
#   source = "./modules/eks-cluster"
#   cluster_name = "jykim-cluster"
#   cluster_version = "1.28"
#   vpc_id = "vpc-00da4c5f837bcb557"
#
#   private_subnets = ["subnet-0de6cfacf5bf294c0", "subnet-00cfad50219c647e5"]
#   public_subnets  = ["subnet-09c355ef67ee5d779", "subnet-03549a56b8aac6a86"]
# }

module "my_vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_web_subnets_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnets_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
}

module "bastion" {
  source        = "./modules/bastion"
  ami_id        = "ami-081a36454cdf357cb"
  instance_type = "t2.micro"
  key_name      = "juyunkey"
  subnet_id     = module.my_vpc.public_subnet_ids[0] // my_vpc 모듈에서 반환된 public_subnets 중 첫 번째 서브넷 사용
  vpc_id        = module.my_vpc.vpc_id // my_vpc 모듈에서 반환된 VPC ID 사용
  name          = "bastion"
  allowed_cidr  = ["0.0.0.0/0"]
  root_volume_size = 20
}


module "rds" {
  source = "./modules/rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name              = "jydb"
  username             = "root"
  password             = "It12345!"
  subnet_ids           = module.my_vpc.private_db_subnet_ids
  #vpc_security_group_ids = [module.bastion.bastion_host_sg_id]
  bastion_security_group_id = module.bastion.bastion_host_sg_id
  tags                 = { Name = "JyDBInstance" }
  vpc_id        = module.my_vpc.vpc_id
  identifier             = "jydb"

}





