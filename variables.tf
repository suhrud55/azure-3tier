variable "resource_group_name" {}
variable "location" {}
variable "admin_username" {}
variable "admin_password" {}

variable "web_vm_size" { default = "Standard_B1s" }
variable "app_vm_size" { default = "Standard_B1s" }
variable "db_vm_size"  { default = "Standard_B1s" }

variable "vnet_cidr"       { default = "10.0.0.0/16" }
variable "web_subnet_cidr" { default = "10.0.1.0/24" }
variable "app_subnet_cidr" { default = "10.0.2.0/24" }
variable "db_subnet_cidr"  { default = "10.0.3.0/24" }