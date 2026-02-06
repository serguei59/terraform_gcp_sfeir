resource "google_compute_instance" "name" {
  name = var.tf_instance
  machine_type = "n1-standard-1"
  allow_stopping_for_update = true
  zone = "europe-west1-c"
  metadata = {
    serial-port-enable = "true"
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

resource "google_compute_firewall"  "name"{
  name = var.tf_firewall
  network = "default"
  description = "Allow connections from IAP"
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
  source_ranges = ["35.235.240.0/20"]
}