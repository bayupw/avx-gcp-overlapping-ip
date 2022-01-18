# Create Site2Cloud IPSec VPN with HA
resource "aviatrix_site2cloud" "prod_onprem_s2c" {
  vpc_id                     = "${module.gcp_prod_vpc.network_name}~-~${var.gcp_project_id}"
  connection_name            = "prod-to-onprem-s2c"
  connection_type            = "mapped"
  remote_gateway_type        = "generic"
  tunnel_type                = "route"
  enable_ikev2               = true
  primary_cloud_gateway_name = resource.aviatrix_spoke_gateway.gcp_prod_spoke.gw_name
  remote_gateway_ip          = module.vpn_onprem_prod.gateway_ip
  pre_shared_key             = var.pre_shared_key

  ha_enabled                = true
  enable_event_triggered_ha = true
  backup_gateway_name       = resource.aviatrix_spoke_gateway.gcp_prod_spoke.ha_gw_name
  backup_remote_gateway_ip  = module.vpn_onprem_prod.gateway_ip
  backup_pre_shared_key     = var.pre_shared_key

  custom_mapped         = false
  remote_subnet_cidr    = var.overlap_cidr        # Private Subnet which overlaps at On-Prem VPC e.g. 10.1.0.0/24
  remote_subnet_virtual = var.onprem_virtual_cidr # Virtual CIDR for On-Prem VPC e.g. 172.17.0.0/24
  local_subnet_cidr     = var.overlap_cidr        # Private Subnet which overlaps at Produdction VPC e.g. 10.1.0.0/24
  local_subnet_virtual  = var.prod_virtual_cidr   # Virtual CIDR for On-Prem VPC e.g. 172.16.0.0/24
}