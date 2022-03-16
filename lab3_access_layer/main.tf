### Access layer management 

# Configure Check Point Provider
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

### Host object
resource "checkpoint_management_host" "host1" {
  ipv4_address = "10.99.2.30"
  name = "host_10.99.2.30"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

### Network object
resource "checkpoint_management_network" "network1" {
  subnet4 = "10.32.0.0"
  mask_length4 = "16"
  name = "net_10.32.0.0_m16"
  color = "red"
  nat_settings = {
    auto_rule = true
    method = "hide"
    hide_behind = "gateway"
    install_on = "All"
  }
}

resource "checkpoint_management_access_layer" "aut_layer_1" {
  name = "aut_layer_1"
  applications_and_url_filtering = true
  firewall =true
  color = "blue"
}

resource "checkpoint_management_access_rule" "rule1" {
  layer = checkpoint_management_access_layer.aut_layer_1.name
  enabled = true
  name = "Rule1"  
  position = {top = "top"}
  source = [ checkpoint_management_host.host1.name ]
  destination = ["All_Internet"]    
  track = {
    accounting = true
    alert = "none"
    enable_firewall_session = true
    per_connection = true
    per_session = true
    type = "Log"
    }  
  action = "Accept"
  lifecycle {
      ignore_changes = [action]
      }
  }

resource "checkpoint_management_access_rule" "rule2" {
  layer = checkpoint_management_access_layer.aut_layer_1.name
  enabled = true
  name = "Rule2"  
  position = {below = checkpoint_management_access_rule.rule1.name}
  source = [ checkpoint_management_network.network1.name ]
  destination = ["All_Internet"]    
  track = {
    accounting = true
    alert = "none"
    enable_firewall_session = true
    per_connection = true
    per_session = true
    type = "Log"
    }  
  action = "Accept"
  lifecycle {
      ignore_changes = [action]
      }
  }

                
# resource "checkpoint_management_access_rule" "allowrule2" {
#                 name = "Allowed Categories"
#                 enabled = true
#                 action = "Accept"
#                 action_settings = {
#                   enable_identity_captive_portal = false
#                   }
#                 destination = ["All_Internet"]
#                 service = [ "Low Risk", "Very Low Risk", "Medium Risk" ]
#                 layer = checkpoint_management_access_layer.aut_layer_1.name
#                 track = {
#                   accounting = true
# 	                alert = "none"
#                   enable_firewall_session = true
#                   per_connection = true
#                   per_session = true
#                   type = "Log"
#                   }
#                 position = {below = checkpoint_management_access_rule.blockrule1.name}
#                 lifecycle {
#                    ignore_changes = [action]
#                    }
#                 }