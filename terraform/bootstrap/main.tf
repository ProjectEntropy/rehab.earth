resource "digitalocean_droplet" "bootstrap" {
  image = "${var.base_snapshot_id}"
  name = "bootstrap"
  region = "${var.region}"
  size = "${var.size}"
  private_networking = true

  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("${var.pvt_key}")}"
    timeout = "2m"
  }

  provisioner "file" {
    source = "scripts/all_the_things.sh"
    destination = "/root/all_the_things.sh"
  }

  provisioner "file" {
    source = "scripts/export_root_token.sh"
    destination = "/root/export_root_token.sh"
  }

  provisioner "file" {
    source = "${var.pvt_key}"
    destination = "/root/DO_SSH_KEY"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      # Until chef arrives,
      "bash all_the_things.sh ${var.project_branch} ${var.project} ${var.do_token} ${var.ssh_fingerprint} ${var.base_snapshot_id} ${var.tz}",
    ]
  }
}
