# Look up (don't create) the account's default VPC
data "aws_vpc" "default" {
  default = true
}

# Look up the us-east-1a subnet in that VPC (same one you picked in the console)
data "aws_subnet" "a" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
  default_for_az    = true
}