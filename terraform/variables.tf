variable "project_id" {
  description = "ID du projet GCP"
  type = string
}

variable "region" {
  description = "Région GCP"
  type = string
  default = "europe-west1"
}

variable "tf_instance" {
  description = "nom de l'instance"
  type = string  
}

variable "tf_firewall" {
  description = "nom du firewall"
  type = string
}