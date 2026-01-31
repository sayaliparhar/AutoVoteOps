# created an iam instance profile so, we can attach this role to ec2 Instances

resource "aws_iam_instance_profile" "s3_instance_profile" {
  name = "s3-instance-profile"
  role = aws_iam_role.s3_access_role.name
}