# Create Aviatrix Spoke Gateway with HA in Production VPC
resource "aviatrix_spoke_gateway" "gcp_prod_spoke" {
  cloud_type                        = 4 # GCP Cloud Type
  account_name                      = var.gcp_account_name
  gw_name                           = "${module.gcp_prod_vpc.subnets_regions[0]}spokegw"
  vpc_id                            = module.gcp_prod_vpc.network_name
  vpc_reg                           = "${var.gcp_region}-a"
  gw_size                           = var.gw_size
  subnet                            = module.gcp_prod_vpc.subnets_ips[0]
  ha_subnet                         = module.gcp_prod_vpc.subnets_ips[0]
  ha_zone                           = "${var.gcp_region}-b"
  ha_gw_size                        = var.gw_size
  single_ip_snat                    = false
  enable_active_mesh                = true
  manage_transit_gateway_attachment = false
}