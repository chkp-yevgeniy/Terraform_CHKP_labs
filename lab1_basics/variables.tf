variable "host2_ip" {
  default="10.100.0.2"
}

variable "host2_name" {  
  default="host"
}

variable "host3" {  
  #type="map"
  default={
    name="host3"
    ip="10.101.0.3"    
  }

}
