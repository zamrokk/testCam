#####################################################################
##
##      12/09/18 : création par admin. Pour le cloud Aucun(e) pour test
##
#####################################################################

variable "user" {
  type = "string"
  description = "Généré"
}

variable "password" {
  type = "string"
  description = "Généré"
}

variable "vsphere_server" {
  type = "string"
  description = "Généré"
}

variable "allow_unverified_ssl" {
  type = "string"
  description = "Généré"
}

variable "vm_name" {
  type = "string"
  description = "Virtual machine name for vm"
}

variable "vm_number_of_vcpu" {
  type = "string"
  description = "Number of virtual cpu's."
}

variable "vm_memory" {
  type = "string"
  description = "Memory allocation."
}

variable "vm_disk_name" {
  type = "string"
  description = "The name of the disk. Forces a new disk if changed. This should only be a longer path if attaching an external disk."
}

variable "vm_disk_size" {
  type = "string"
  description = "The size of the disk, in GiB."
}

variable "vm_template_name" {
  type = "string"
  description = "Généré"
}

variable "vm_datacenter_name" {
  type = "string"
  description = "Généré"
}

variable "vm_datastore_name" {
  type = "string"
  description = "Généré"
}

variable "resource_pool_cluster_name" {
  type = "string"
  description = "Cluster name"
}

variable "network_network_name" {
  type = "string"
  description = "Généré"
}

variable "vm_connection_user" {
  type = "string"
  default = "root"
}

variable "vm_connection_password" {
  type = "string"
}

variable "vm_connection_host" {
  type = "string"
}

variable "ucd_user" {
  type = "string"
  description = "UCD User."
  default = "admin"
}

variable "ucd_password" {
  type = "string"
  description = "UCD Password."
}

variable "ucd_server_url" {
  type = "string"
  description = "UCD Server URL."
  default = "https://192.168.63.12:31464"
}

variable "environment_name" {
  type = "string"
  description = "Environment name"
}

variable "vm_agent_name" {
  type = "string"
  description = "Agent name"
}

