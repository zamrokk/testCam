#####################################################################
##
##      12/09/18 : création par admin. Pour le cloud Aucun(e) pour test
##
#####################################################################

## REFERENCE {"vsphere_network":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}

provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}


data "vsphere_virtual_machine" "vm_template" {
  name          = "${var.vm_template_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_datacenter.id}"
}

data "vsphere_datacenter" "vm_datacenter" {
  name = "${var.vm_datacenter_name}"
}

data "vsphere_datacenter" "vm_datacenter_name" {
  name = "${var.vm_datacenter_name}"
}

data "vsphere_datastore" "vm_datastore" {
  name          = "${var.vm_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_datacenter.id}"
}

data "vsphere_resource_pool" "resource_pool_cluster" {
  name          = "${var.resource_pool_cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_datacenter_name.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_network_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_datacenter.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name          = "${var.vm_name}"
  datastore_id  = "${data.vsphere_datastore.vm_datastore.id}"
  num_cpus      = "${var.vm_number_of_vcpu}"
  memory        = "${var.vm_memory}"
  guest_id = "${data.vsphere_virtual_machine.vm_template.guest_id}"
  resource_pool_id = "${data.vsphere_resource_pool.resource_pool_cluster.id}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  connection {
    type = "ssh"
    user = "${var.vm_connection_user}"
    password = "${var.vm_connection_password}"
    host = "${var.vm_connection_host}"
  }
  provisioner "file" {
    destination = "/home"
    content     = <<EOT
test
EOT
}
  
  provisioner "ucd" {
    agent_name      = "${var.vm_agent_name}.${random_id.vm_agent_id.dec}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.vm_agent_name}.${random_id.vm_agent_id.dec} -X DELETE
EOT
}
  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm_template.id}"
  }
  disk {
    name = "${var.vm_disk_name}"
    size = "${var.vm_disk_size}"
  }
}

resource "ucd_component_mapping" "testComponent" {
  component = "testComponent"
  description = "testComponent Component"
  parent_id = "${ucd_agent_mapping.vm_agent.id}"
}

resource "random_id" "vm_agent_id" {
  byte_length = 8
}

resource "ucd_component_process_request" "testComponent" {
  component = "testComponent"
  environment = "${ucd_environment.environment.id}"
  process = "createFile"
  resource = "${ucd_component_mapping.testComponent.id}"
  version = "LATEST"
}

resource "ucd_resource_tree" "resource_tree" {
  base_resource_group_name = "Base Resource for environment ${var.environment_name}"
}

resource "ucd_environment" "environment" {
  name = "${var.environment_name}"
  application = "testApplication"
  base_resource_group ="${ucd_resource_tree.resource_tree.id}"
}

resource "ucd_agent_mapping" "vm_agent" {
  depends_on = [ "vsphere_virtual_machine.vm" ]
  description = "Agent to manage the vm server"
  agent_name = "${var.vm_agent_name}.${random_id.vm_agent_id.dec}"
  parent_id = "${ucd_resource_tree.resource_tree.id}"
}