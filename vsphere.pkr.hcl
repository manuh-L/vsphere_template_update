# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "vsphere-clone" "MGlobal" {
  communicator        = "ssh"
  host                = "192.168.100.100"
  insecure_connection = "true"
  password            = "Password1!"
  template            = "TMP-CentOS8"
  username            = "administrator@vsphere.local"
  vcenter_server      = "vcsa-01.lab.com"
  cluster             = "Tanzu-Cluster"
  vm_name             = "TMP-latest"
  notes               = "Template created on ${local.timestamp}"
  convert_to_template = "true"
  ssh_username        = "root"
  ssh_password        = "Password1"
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-clone.MGlobal"]

#https://www.packer.io/docs/provisioners
  provisioner "shell-local" {
    inline = ["ip a", "hostname"]
  }

  provisioner "ansible" {
    playbook_file = "./default-config.yml"
      extra_arguments = ["-v"]

    }
}