provider "aws" {
  region     = "eu-west-2"
  access_key = "xxxxxxxxx"  //hidden accesskey as not safe to push
  secret_key = "xxxxxx" //hidden accesskey as not safe to pus
}


resource "aws_s3_bucket" "bucket_A" {
  bucket = var.bucket_A
  acl    = "public-read"

  tags = {
    Name = "Bucket_A"
  }
}


resource "aws_s3_bucket" "B" {
  bucket = var.bucket_B
  acl    = "public-read_write"

  tags = {
    Name = "Bucket_B"
  }
}

resource "aws_lambda_function" "functio_to_remove_metadata" {
  filename      = "lambda_function_payload.zip"
  function_name = "function_to_remove_metadata"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.test"
  runtime       = "python3.8"
}


resource "aws_iam_role" "iam_for_lambda" {
 name               = "iam_for_lambda"
assume_role_policy=<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
        "s3:GetObject",
        "s3:ListObject",
        "s3:ListBucket"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
