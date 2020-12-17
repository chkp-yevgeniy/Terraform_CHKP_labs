### Access layer management 


# Configure the Check Point Provider
provider "checkpoint" {
    # Set them via env vars   
}

module "host_1" {
  source = "./modules/host"  
  host = { 
    name="host5"
    ip="10.99.0.5"  
  }   
}

module "host_2" {
  source = "./modules/host"  
  host = { 
    name="host6"
    ip="10.99.0.6"  
  }   
}