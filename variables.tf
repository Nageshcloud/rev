variable "aws_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}
variable "aws_subnet_names" {
    type = list(string)
    default = [ "web1","web2","app1","app2","db1","db2" ]
  
}
variable "aws_subnets_azs" {
    type = list(string)
    default = [ "ap-southeast-1a","ap-southeast-1b","ap-southeast-1a","ap-southeast-1b","ap-southeast-1a","ap-southeast-1b" ]
  
}
  variable "public_subnets" {
    type = list(string)
    default = [ "web1", "web2" ]
}

variable "app_subnets" {
    type = list(string)
    default = [ "app1", "app2" ]
}

variable "appserver_info" {
    type                 = object ({
     count               = number
     ami                 = string
     instance_type       = string
     public_ip_enabled   = bool
      key_name           = string
     public_key_path     = string
    })
    default = {
        
        
        hgakehgowuhguowhgouhwojghowhgouwh
        key_name           = "my_keypair"
     public_key_path       = "~/.ssh/id_rsa.pub"
     count                 = 2
     ami                   =  "ami-02ee763250491e04a"
     instance_type         = "t2.micro"
     public_ip_enabled     = true
     Name                  = "appserver"
    }
}
  
vdbkjjkgrhwjohouuy9u3btugh nkjgiuy974yenvjdhgrouhygnvhn
