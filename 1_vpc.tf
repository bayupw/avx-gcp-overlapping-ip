# Create Production VPC
module "gcp_prod_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id                             = var.gcp_project_id
  network_name                           = "production-vpc"
  routing_mode                           = "REGIONAL"
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name   = "prod-subnet"
      subnet_ip     = var.overlap_cidr
      subnet_region = var.gcp_region
    }
  ]
}

# Create default route in Production VPC with "public" instance tags
resource "google_compute_route" "prod_internet_route" {
  project          = var.gcp_project_id
  name             = "${module.gcp_prod_vpc.network_name}-internet-route"
  dest_range       = "0.0.0.0/0"
  network          = module.gcp_prod_vpc.network_name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = ["public"]
}

# Create Simulated On-Prem VPC
module "onprem_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id                             = var.gcp_project_id
  network_name                           = "onprem-vpc"
  routing_mode                           = "REGIONAL"
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name   = "onprem-subnet"
      subnet_ip     = var.overlap_cidr
      subnet_region = var.gcp_region
    }
  ]
}

# Create default route in Simulated On-Prem VPC with "public" instance tags
resource "google_compute_route" "onprem_internet_route" {
  project          = var.gcp_project_id
  name             = "${module.onprem_vpc.network_name}-internet-route"
  dest_range       = "0.0.0.0/0"
  network          = module.onprem_vpc.network_name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  tags             = ["public"]
}