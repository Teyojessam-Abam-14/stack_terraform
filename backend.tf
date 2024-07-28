terraform{
         backend "s3"{
                bucket= "stackbucketstate-teejay"
                key = "terraform.tfstate"
                region= "us-east-1"
                dynamodb_table= "statelock-tf"
                #role_arn = "arn:aws:iam::058264285478:role/Engineer"  #Automation 1 Engineer 
                #NB: (Unhash the role above when running locally, hash it again and push to Git when running on Jenkins)
                 }
 }

#NB: terraform init -reconfigure (Move the state file from local to S3)
#NB: terraform init -migrate-state (Move the state file from S3 back to local)

#To "terraform init"-ialize the state file locally, hash the whole "backend" resource (delete the ".terraform" folder first)