
# Configure the Check Point Provider
provider "checkpoint" {
    # Set them via env vars   
}

### Host object
resource "checkpoint_management_host" "host1" {
  ipv4_address = "10.99.1.22"
  name = "host_10.99.1.22"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

### Network object
resource "checkpoint_management_network" "network1" {
  subnet4 = "10.30.0.0"
  mask_length4 = "16"
  name = "net_10.30.0.0_m16"
  color = "red"
  nat_settings = {
    auto_rule = true
    method = "hide"
    hide_behind = "gateway"
    install_on = "All"
  }
}


### DNS domain
resource "checkpoint_management_dns_domain" "jumphost" {
  name = ".abcd.duckdns.org"
  is_sub_domain = false
  color = "blue"
  }


### Service
resource "checkpoint_management_service_tcp" "tcp1020" {
  port = "1020"
  name = "tcp_1020"
  color = "blue"
  match_for_any = false 
}

### Service other 
resource "checkpoint_management_service_other" "other_AH" {
  name = "AutHeader"
  keep_connections_open_after_policy_installation = false
  session_timeout = 100
  match_for_any = true
  sync_connections_on_cluster = true
  ip_protocol = 51
}


### Dynamic object
resource "checkpoint_management_dynamic_object" "localgatewayinternal" {
  name = "LocalGatewayInternal"
  color = "blue"
}


# Policy package
resource "checkpoint_management_package" "aut_policy" {
  name = "Aut_Policy"
  color = "orange"
  threat_prevention = false
  access = true  
  #
  lifecycle {
    ignore_changes = [installation_targets]
  }
}


### Rules
resource "checkpoint_management_access_rule" "allowrule1" {
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  position = {top = "top"}
  enabled = true  
  name = "Rule1"  
  source = [ checkpoint_management_host.host1.name ]  
  destination = [ checkpoint_management_network.network1.name ]
  service = [ checkpoint_management_service_other.other_AH.name ]  
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


resource "checkpoint_management_access_rule" "allowrule2" {
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  position = {below = checkpoint_management_access_rule.allowrule1.name}
  enabled = true  
  name = "Rule2"    
  destination = [ checkpoint_management_network.network1.name ]
  source = [ checkpoint_management_host.host1.name ]  
  service = [ checkpoint_management_service_tcp.tcp1020.name ]  
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

resource "checkpoint_management_access_rule" "allowrule3" {
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  position = {below = checkpoint_management_access_rule.allowrule2.name}
  enabled = true  
  name = "Rule3"    
  destination = [ checkpoint_management_network.network1.name ]
  source = [ checkpoint_management_dynamic_object.localgatewayinternal.name ]  
  
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


resource "checkpoint_management_access_rule" "allowrule4" {
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  position = {below = checkpoint_management_access_rule.allowrule3.name}
  enabled = true  
  name = "Rule4"    
  destination = [ checkpoint_management_network.network1.name ]
  source = [ checkpoint_management_dynamic_object.localgatewayinternal.name ]  
  
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



resource "checkpoint_management_access_section" "section1" {
  name = "Section1"
  position = {above = checkpoint_management_access_rule.allowrule1.name}
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  }

resource "checkpoint_management_access_section" "section2" {
  name = "Section2"
  position = {above = "Cleanup rule"}
  layer = "${checkpoint_management_package.aut_policy.name} Network"
  }


# resource "checkpoint_management_verify_policy" "verify" {
#   policy_package = checkpoint_management_package.aut_policy.name
# }  

# resource "checkpoint_management_install_policy" "example" {
#   policy_package = "standard"
#   targets = ["corporate-gateway"]
# }

