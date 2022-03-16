### Access layer management 


# Configure the Check Point Provider
terraform {
  required_providers {
    checkpoint = {
      source  = "checkpointsw/checkpoint"
      version = "~> 1.6.0"
    }
  }
}
provider "checkpoint" {
    # Set them via env vars   
}


### Host object with variable as list of dictionaries
resource "checkpoint_management_host" "host2" {  
  for_each = {for host in var.hosts:  host.name => host}
  ipv4_address = "${each.value.ip}"
  name = "${each.value.name}"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

