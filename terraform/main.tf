resource "google_compute_instance" "name" {
  name = var.tf_instance
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  zone = "europe-west1-c"
  metadata = {
    serial-port-enable = true
  }
  network_interface {
    network = "default"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"    
    }
  }
}