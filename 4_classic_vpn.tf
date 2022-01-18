# Create GCP Classic VPN with 2 tunnels
module "vpn_onprem_prod" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0"

  project_id         = var.gcp_project_id
  region             = var.gcp_region
  network            = module.onprem_vpc.network_name
  gateway_name       = "vpn-onprem"
  tunnel_name_prefix = "vpn-onprem-prod"
  shared_secret      = var.pre_shared_key
  tunnel_count       = 2
  peer_ips           = [resource.aviatrix_spoke_gateway.gcp_prod_spoke.eip, resource.aviatrix_spoke_gateway.gcp_prod_spoke.ha_eip]

  route_priority = 1000
  remote_subnet  = [var.prod_virtual_cidr]

  ike_version = 2
}