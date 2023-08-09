resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }


}

#Create folder
resource "aws_s3_bucket_object" "folder" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "my_folder/" 
  acl    = "private"        
}


 resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "${aws_s3_bucket_object.folder.key}sample.JPG" #Uploads a file into the folder by appending the folder key to file key
  source = "C://Users//teyoj//Pictures//sample_pic.JPG"
  acl    = "private" 

}
