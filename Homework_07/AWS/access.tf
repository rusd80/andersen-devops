#--------- TLS KEY ----------------
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/eu-key.pem"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}
#-----------------------------------