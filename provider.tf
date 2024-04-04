provider "aws" {
# region = var.AWS_REGION
# access_key = var.AWS_ACCESS_KEY
# secret_key = var.AWS_SECRET_KEY

# assume_role {
#     role_arn = "arn:aws:iam::721636561061:role/Engineer"
# } 

default_tags {
   tags = {
      environment = "dev"
      # #sandbox, dev, test, qa, uat, stage, prod, hotfix, train, mgmt
   }
 }

}