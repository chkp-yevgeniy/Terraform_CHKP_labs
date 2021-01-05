
# Overview
Labs are built as working examples giving a good starting point to use Terraform for Check Point management server automation. 


# What does it do?
Labs allows you to create objects (hosts, networks, services), policies, layers, rulebases on Check Point management server. 


# Requirements
A Check Point management server => R80.10
Terraform 

# Usage
1. Activate API on Check Point management server:  
https://community.checkpoint.com/t5/API-CLI-Discussion/Enabling-web-api/td-p/32641


2. Configurre vars as enviromental vars in following way (adjust the values according to your env.): 

- For multi-domain management:
export CHECKPOINT_SERVER="192.168.168.10"
export CHECKPOINT_USERNAME="admin2"
export CHECKPOINT_PASSWORD="qwe123"
export CHECKPOINT_CONTEXT="web_api"
export CHECKPOINT_TIMEOUT=30
export CHECKPOINT_DOMAIN="CMA2"
export CHECKPOINT_PORT="443"

- For management server:
export CHECKPOINT_SERVER="192.168.168.10"
export CHECKPOINT_USERNAME="admin2"
export CHECKPOINT_PASSWORD="qwe123"
export CHECKPOINT_CONTEXT="web_api"
export CHECKPOINT_TIMEOUT=30
export CHECKPOINT_PORT="443"


3. In command lile, change into lab folder and executer following commands:

- terraform init       - Download Terraform Check Point provider 
- terraform apply      - Perform configuration according to Terraform code
- ./publish_logout.py  - Apply configuration changes to management server and logout


# References
Terraform Check Point Provider:    
https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs

Terraform introduction:  
https://www.terraform.io/intro/index.html

Enabling Check Point API:  
https://community.checkpoint.com/t5/API-CLI-Discussion/Enabling-web-api/td-p/32641

