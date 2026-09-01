# Entry point file for Terraform execution.
# Resource configurations have been modularized into separate files:
# - provider.tf  : Cloud provider configuration
# - variables.tf : Input variables
# - network.tf   : VPC, Subnets, Gateway, and Routing
# - interface.tf : Security Groups and Firewall rules
# - vm.tf        : Compute Instance and User Data scripts
# - outputs.tf   : Output variables