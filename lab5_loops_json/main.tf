### Access layer management 

# Configure the Check Point Provider
provider "checkpoint" {
    # Set them via env vars   
}


### Host objects from a list of dictionaries
resource "checkpoint_management_host" "host" {  
  for_each = {for host in var.hosts:  host.name => host}  
  ipv4_address = each.value.ip
  name = each.value.name
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}


### Network objects from a list of dictionaries
resource "checkpoint_management_network" "network" {  
  for_each = {for network in var.networks:  network.name => network}
  name = each.value.name
  subnet4 = each.value.ip
  mask_length4 = each.value.masklength
  color = "red" 
}


### Policy packages from a list of dictionaries
resource "checkpoint_management_package" "policy_package" {
  for_each = {for package in var.packages:  package.name => package}
  name = each.value.name
  color = each.value.color
  threat_prevention = each.value.threat_prevention
  access = each.value.access
  lifecycle {
    ignore_changes = [installation_targets]
  }
}


### Sections from a list of dictionaries
resource "checkpoint_management_access_section" "section" {
  for_each = {for section in var.sections:  section.name => section}
  name = each.value.name  
  position = each.value.position
  layer = "${each.value.layer} Network"  
  #depends_on = [ checkpoint_management_package.policy_package["AutPolicy_1"] ] # supported 
  # depends_on = each.value.depends_on # Not supported  
  depends_on = [ checkpoint_management_package.policy_package ]
}


###  Access rules from a list of dictionaries
resource "checkpoint_management_access_rule" "rule" {
  for_each = {for access_rule in var.access_rules:  access_rule.name => access_rule}    
  layer = "${each.value.layer} Network"
  name = each.value.name
  enabled = each.value.enabled
  source = each.value.source   
  destination = each.value.destination   
  #service = [ ]
  action = each.value.action  
  track = {
    accounting = each.value.track_accounting
    alert = "none"
    enable_firewall_session =false
    per_connection = true
    per_session = true
    type = each.value.track_type
  }  
  position = each.value.position  
  depends_on = [ checkpoint_management_host.host, checkpoint_management_network.network, checkpoint_management_access_section.section, checkpoint_management_package.policy_package ]
}


