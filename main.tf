terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = ">= 2.15"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 2.12.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=3.1.0"
    }
  }
}

provider "aviatrix" {}