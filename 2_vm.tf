# Create firewall rule with target tags in Production VPC
resource "google_compute_firewall" "prod_ssh_http" {
  name    = "allow-prod-ssh-http-icmp"
  network = module.gcp_prod_vpc.network_name
  project = var.gcp_project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prod-ssh-http-icmp"]
}

# Create firewall rule with target tags in Simulated On-Prem VPC
resource "google_compute_firewall" "onprem_ssh_http_icmp" {
  name    = "allow-onprem-ssh-http-icmp"
  network = module.onprem_vpc.network_name
  project = var.gcp_project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["onprem-ssh-http-icmp"]
}

# Create a VM instance in Production VPC Zone A
resource "google_compute_instance" "prod_public_instance_a" {
  name         = "${module.gcp_prod_vpc.subnets_names[0]}-public-a"
  machine_type = "f1-micro"
  zone         = "${module.gcp_prod_vpc.subnets_regions[0]}-a"
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork         = module.gcp_prod_vpc.subnets_names[0]
    subnetwork_project = var.gcp_project_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  tags = ["prod-ssh-http-icmp", "public"]
}

# Create a VM instance in Production VPC Zone B
resource "google_compute_instance" "prod_public_instance_b" {
  name         = "${module.gcp_prod_vpc.subnets_names[0]}-public-b"
  machine_type = "f1-micro"
  zone         = "${module.gcp_prod_vpc.subnets_regions[0]}-b"
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork         = module.gcp_prod_vpc.subnets_names[0]
    subnetwork_project = var.gcp_project_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  tags = ["prod-ssh-http-icmp", "public"]
}

# Create a VM instance in Simulated On-Prem VPC Zone A
resource "google_compute_instance" "onprem_public_instance_a" {
  name         = "${module.onprem_vpc.subnets_names[0]}-public-a"
  machine_type = "f1-micro"
  zone         = "${module.onprem_vpc.subnets_regions[0]}-a"
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork         = module.onprem_vpc.subnets_names[0]
    subnetwork_project = var.gcp_project_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  tags = ["onprem-ssh-http-icmp", "public"]
}

# Create a VM instance in Simulated On-Prem VPC Zone B
resource "google_compute_instance" "onprem_public_instance_b" {
  name         = "${module.onprem_vpc.subnets_names[0]}-public-b"
  machine_type = "f1-micro"
  zone         = "${module.onprem_vpc.subnets_regions[0]}-b"
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork         = module.onprem_vpc.subnets_names[0]
    subnetwork_project = var.gcp_project_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  tags = ["onprem-ssh-http-icmp", "public"]
}

output "prod_public_instance_a_ip" {
  value = google_compute_instance.prod_public_instance_a.network_interface.0.access_config.0.nat_ip
}

output "prod_public_instance_b_ip" {
  value = google_compute_instance.prod_public_instance_b.network_interface.0.access_config.0.nat_ip
}

output "onprem_public_instance_a_ip" {
  value = google_compute_instance.onprem_public_instance_a.network_interface.0.access_config.0.nat_ip
}

output "onprem_public_instance_b_ip" {
  value = google_compute_instance.onprem_public_instance_b.network_interface.0.access_config.0.nat_ip
}