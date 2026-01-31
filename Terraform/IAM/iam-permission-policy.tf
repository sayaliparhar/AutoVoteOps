# creating appropriate permission of s3-bucket
data "aws_iam_policy_document" "s3_permissions_ds" {
  statement {
    actions   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
    resources = [
      "arn:aws:s3:::autovotewebapp",
      "arn:aws:s3:::autovotewebapp/*"
    ]
  }
}

# s3-bucket-restricted-policy created
resource "aws_iam_policy" "s3_access_policy" {
  name   = "my-s3-access-policy"
  policy = data.aws_iam_policy_document.s3_permissions_ds.json
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}