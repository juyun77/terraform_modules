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