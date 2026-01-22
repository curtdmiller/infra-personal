data "onepassword_item" "lightsail_ssh_key" {
  vault = var.onepassword_key_vault
  uuid  = var.onepassword_ssh_key_uuid
}

resource "aws_lightsail_key_pair" "imported_key" {
  name       = "lightsail-sites-key"
  public_key = data.onepassword_item.lightsail_ssh_key.public_key
}

resource "aws_lightsail_instance" "sites_instance" {
  name              = "sites-instance"
  availability_zone = "us-east-2a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "micro_3_0"
  key_pair_name     = aws_lightsail_key_pair.imported_key.name
  user_data         = templatefile("${path.module}/user-data.sh.tpl", { PUBLIC_KEY = data.onepassword_item.lightsail_ssh_key.public_key })
}

resource "aws_lightsail_static_ip" "sites_static_ip" {
  name = "sites-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "sites_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.sites_static_ip.name
  instance_name  = aws_lightsail_instance.sites_instance.name
}