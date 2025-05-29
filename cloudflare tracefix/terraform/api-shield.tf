# Terraform module for Cloudflare API Shield
# This file manages schema validation and endpoint labeling

resource "cloudflare_api_shield_schema" "main" {
  zone_id = var.cloudflare_zone_id
  schema  = file("${path.module}/../schemas/merged.schema.json")
}

resource "cloudflare_api_shield_labels" "main" {
  zone_id = var.cloudflare_zone_id
  labels  = jsondecode(file("${path.module}/../schemas/labels.json"))
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}
