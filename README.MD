*This repo contains files for the pipeline that automates the creation of vsphere template image with GitLab CI/CD + Packer + Ansible*

# Pre-requirement
Python library (PyVmomi) on the gitlab runner

# .gitlab-ci.yml
The gitlab CI/CD pipeline file with all the stages and jobs

# default-config.yml
Playbook for OS configuration & hardening

# input.yml
File with all the variables for the playbooks

# template-rename.yml
Ansible playbook to rename the latest template to "TMP-CentOS8" during the execution of the pipeline

# vsphere.pkr.hcl
Is the Packer IaC file, contains the code to clone the template with embeeded ansible provisioner to update the OS and other OS configs & hardening

** Enviroment Variables
vc_user: "{{ lookup('env','VC_USER') }}"
vc_passwd: "{{ lookup('env','VC_PASSWD') }}"
are env variables on gitlab server