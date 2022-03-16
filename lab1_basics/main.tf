
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
  # We will set them via env vars
  # server   = "203.0.113.80"
  # username = "api_user"
  # password = "vpn123"
  # context  = "web_api"   
}

### Host object
resource "checkpoint_management_host" "host1" {
  ipv4_address = "10.100.0.1"
  name = "host_10.100.0.1"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

### Host object with variables
resource "checkpoint_management_host" "host2" {
  ipv4_address = var.host2_ip
  name = "${var.host2_name}_${var.host2_ip}"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

### Host object with variable as map 
resource "checkpoint_management_host" "host3" {
  ipv4_address = var.host3["ip"]
  name = var.host3["name"]
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}





