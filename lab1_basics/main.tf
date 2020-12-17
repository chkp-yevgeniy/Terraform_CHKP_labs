
# Configure the Check Point Provider
provider "checkpoint" {
    # Set them via env vars   
}

### Host object
resource "checkpoint_management_host" "host1" {
  ipv4_address = "10.99.0.1"
  name = "host_10.99.0.1"
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





