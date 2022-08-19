resource "aws_vpc" "main" {
  cidr_block       = var.aws_cidr
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnets" {
  count=length(var.aws_subnet_names)
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.aws_cidr,8,count.index)
  availability_zone = var.aws_subnets_azs[count.index]

  tags = {
    Name = var.aws_subnet_names[count.index]
  }
}


resource "aws_security_group" "web_secur_grp" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = local.ssh_port
    to_port          = local.ssh_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }
   ingress {
    from_port        = local.http_port
    to_port          = local.http_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }


  egress {
    from_port        = local.any_port
    to_port          = local.any_port
    protocol         = local.any_protocol
    cidr_blocks      = [local.anywhere]
    ipv6_cidr_blocks = [local.anywhere_ipv6]
  }

  tags = {
    Name = "web_secur_grp"
  }
}

resource "aws_security_group" "app_secur_grp" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = local.ssh_port
    to_port          = local.ssh_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }
   ingress {
    from_port        = local.app_port
    to_port          = local.app_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }


  egress {
    from_port        = local.any_port
    to_port          = local.any_port
    protocol         = local.any_protocol
    cidr_blocks      = [local.anywhere]
    ipv6_cidr_blocks = [local.anywhere_ipv6]
  }

  tags = {
    Name = "app_secur_grp"
  }
}

resource "aws_internet_gateway" "for_web_server" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "for_web_server"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.for_web_server.id
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route_table_association" "associations" {
    count               = length(aws_subnet.subnets)
    subnet_id           = aws_subnet.subnets[count.index].id
    route_table_id      = contains(var.public_subnets, lookup(aws_subnet.subnets[count.index].tags_all, "Name", ""))?aws_route_table.public.id :  aws_route_table.private.id
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.appserver_info.key_name
  public_key = file(var.appserver_info.public_key_path)
}

resource "aws_instance" "appserver" {
  count                         = var.appserver_info.count
   ami                          = var.appserver_info.ami 
    instance_type               = var.appserver_info.instance_type
   associate_public_ip_address  = var.appserver_info.public_ip_enabled
   key_name                     = var.appserver_info.key_name
   subnet_id                    = data.aws_subnets.app_subnets.ids[count.index]
   vpc_security_group_ids       = [aws_security_group.app_secur_grp.id]
  
}


