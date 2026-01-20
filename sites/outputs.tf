output "sites_static_ip_address" {
  description = "The static IP address of the Lightsail instance."
  value       = aws_lightsail_static_ip.sites_static_ip.ip_address
}