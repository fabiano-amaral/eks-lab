locals {
  name      = "lab"
  partition = data.aws_partition.current.partition
  region    = "us-east-1"
  tags = {
  }
}
