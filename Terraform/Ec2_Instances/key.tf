resource "aws_key_pair" "terra-key" {
  key_name = "vote"
 public_key = file ("${path.module}/Key/vote.pub") 
}