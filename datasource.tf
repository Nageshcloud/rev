data "aws_subnets" "db_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
 filter {
    name   = "tag:name"
    values = [ "db1", "db2" ]
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

data "aws_subnets" "app_subnets" {
   filter {
    name   = "tag:name"
    values = [ "app1","app2" ]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
}
