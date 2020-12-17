

# Hosts as list of dictionaries
variable "hosts" {  
  #type="map"
  default=[
    {
      name="host7"
      ip="10.99.0.7"    
    },
    {
      name="host8"
      ip="10.99.0.8"    
    },
    {
      name="host9"
      ip="10.99.0.9"    
    }
  ]

}

