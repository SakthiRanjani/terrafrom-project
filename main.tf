#root module

module "vpc" {
  source = "./vpc"
}

module "my_ec2" {
  source = "./web"
  sub1 = module.vpc.sub1
  sub2 = module.vpc.sub2
  sg = module.vpc.sg
  vpc = module.vpc.vpc
}

