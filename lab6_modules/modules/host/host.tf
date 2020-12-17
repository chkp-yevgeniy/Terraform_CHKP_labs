
resource "checkpoint_management_host" "my_host" {
  ipv4_address = var.host["ip"]
  name = "${var.host["name"]}_${var.host["ip"]}"
  color = "blue"
  nat_settings = {
    auto_rule = false
  }
}