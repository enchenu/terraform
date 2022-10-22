terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

# Configure the Linode Provider
provider "linode" {
  token = var.do_token
}

resource "linode_instance" "jenkins" {
  label           = "jenkins"
  image           = "linode/ubuntu22.04"
  region          = var.region
  type            = "g6-standard-1"
  authorized_keys = [linode_sshkey.Jornada.ssh_key]
}

resource "linode_sshkey" "Jornada" {
  label   = var.ssh_keyn_name
  ssh_key = chomp(file("~/.ssh/terraform.pub"))
}

# Create a Linode
resource "linode_lke_cluster" "k8s" {
  label       = "k8s"
  k8s_version = "1.23"
  region      = var.region
  tags        = ["prod"]

  pool {
    type  = "g6-standard-1"
    count = 2
  }

  # pool {
  #   type  = "g6-standard-4"
  #   count = 2
  # }

}

variable "do_token" {
  default = ""
}

variable "ssh_keyn_name" {
  default = ""
}

variable "region" {
  default = ""
}

output "jenkins_ip" {
  value = linode_instance.jenkins.ip_address
}

# //Export this cluster's attributes
# output "kubeconfig" {
#   value     = linode_lke_cluster.k8s.kubeconfig
#   sensitive = true
# }

# resource "local_file" "foo" {
#     content  = linode_lke_cluster.k8s.
#     filename = "kube_config.yaml"
# }