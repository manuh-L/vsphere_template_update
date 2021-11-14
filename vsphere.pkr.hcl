# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are analogous to the "builders" in json templates. They are used
# in build blocks. A build block runs provisioners and post-processors on a
# source. Read the documentation for source blocks here:
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

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-clone.MGlobal"]

  provisioner "shell-local" {
    inline = ["ip a", "echo HELLO"]
  }

  provisioner "ansible" {
    playbook_file = "./default-config.yml"
      extra_arguments = ["-v"]

    }
}