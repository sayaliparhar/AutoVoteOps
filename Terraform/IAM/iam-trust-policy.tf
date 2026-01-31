# define trust policy to understand who can use this policy (Ec2)

data "aws_iam_policy_document" "assume_role_ds" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"] # Change to "lambda.amazonaws.com" if needed
    }
  }
}

# creating iam role
resource "aws_iam_role" "s3_access_role" {
  name               = "Cluster-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ds.json
}