data "onepassword_item" "lightsail_ssh_key" {
  vault = "2c3ykejkiljgj6leohwsdyzccm"
  uuid  = "6u2igsenw5ae7o5lubea75n3gm"
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
  user_data         = file("cloud-config.yaml")
}

resource "aws_lightsail_static_ip" "sites_static_ip" {
  name = "sites-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "sites_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.sites_static_ip.name
  instance_name  = aws_lightsail_instance.sites_instance.name
}