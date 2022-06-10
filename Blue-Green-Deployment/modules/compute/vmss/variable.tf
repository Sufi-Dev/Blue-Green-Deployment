variable "resource_group_name" {
  type = string
}
variable "location" {
 type = string 
}
variable "lb_backend_address_pool" {
  type = string

}
variable "load_balancer_inbound_nat_rules_ids" {
  type = string
  
}
variable "subnet_id" {
 type = string 
}