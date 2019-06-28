# Specify the provider (GCP)
provider "google" {
  credentials = "${file("../credentials/service_account.json")}"
  project     = "andela-learning"
  region      = "${var.region}"
}

# Get the default subnet to be used for hosting the instances
data "google_compute_subnetwork" "default_subnetwork" {
  name   = "default"
  region = "${var.region}"
}

# reserve private ip for haproxy-lb 
resource "google_compute_address" "haproxy_lb_internal_address" {
  name         = "haproxy-lb-private-ip-indungu"
  subnetwork   = "${data.google_compute_subnetwork.default_subnetwork.self_link}"
  address_type = "INTERNAL"
  address      = "10.132.0.45"
  region       = "${var.region}"
}

# reserve static ip for haproxy-lb
resource "google_compute_address" "haproxy_lb_static_address" {
  name         = "haproxy-lb-static-ip-indungu"
}

# reserve private ip for master-db 
resource "google_compute_address" "master_db_internal_address" {
  name         = "master-db-private-ip-indungu"
  subnetwork   = "${data.google_compute_subnetwork.default_subnetwork.self_link}"
  address_type = "INTERNAL"
  address      = "10.132.0.45"
  region       = "${var.region}"
}

# reserve private ip for slave-db-01
resource "google_compute_address" "slave_db_01_internal_address" {
  name         = "slave-db-01-private-ip-indungu"
  subnetwork   = "${data.google_compute_subnetwork.default_subnetwork.self_link}"
  address_type = "INTERNAL"
  address      = "10.132.0.46"
  region       = "${var.region}"
}

# reserve private ip for slave-db-02
resource "google_compute_address" "slave_db_02_internal_address" {
  name         = "slave-db-02-private-ip-indungu"
  subnetwork   = "${data.google_compute_subnetwork.default_subnetwork.self_link}"
  address_type = "INTERNAL"
  address      = "10.132.0.47"
  region       = "${var.region}"
}

# Create the master db instance
resource "google_compute_instance" "master-db" {
  name         = "test-master"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "master-db"
    }
  }

  network_interface {
    network = "default"
    network_ip = "${google_compute_address.master_db_internal_address.address}"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "slave-db-01" {
  name         = "test-slave1"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "slaves-db-01"
    }
  }

  network_interface {
    network = "default"
    network_ip = "${google_compute_address.slave_db_01_internal_address.address}"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "slave-db-02" {
  name         = "test-slave2"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "slaves-db-02"
    }
  }

  network_interface {
    network = "default"
    network_ip = "${google_compute_address.slave_db_02_internal_address.address}"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "haproxy-lb" {
  name         = "test-haproxy"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "haproxy-lb-image"
    }
  }

  network_interface {
    network    = "default"
    network_ip = "${google_compute_address.haproxy_lb_internal_address.address}"

    access_config {
      nat_ip = "${google_compute_address.haproxy_lb_static_address.address}"
    }
  }
}
