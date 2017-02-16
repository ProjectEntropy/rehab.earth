resource "digitalocean_droplet" "concourse" {
  image = "centos-7-x64"
  name = "concourse"
  region = "${var.region}"
  size = "2gb"
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
    source = "etc/concourse/docker-compose.yml"
    destination = "/tmp/concourse-docker-compose.yml"
  }

  # Set up chef. No chef-client --local provisioner yet
  provisioner "remote-exec" {
    inline = [
      # Docker
      "yum install -y docker",
      "systemctl start docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      # Concourse
      "mkdir ~/concourse",
      "mv /tmp/concourse-docker-compose.yml ~/concourse/docker-compose.yml",
      "cd ~/concourse",
      "mkdir -p keys/web keys/worker",
      "ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''",
      "ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''",
      "ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''",
      "cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys",
      "cp ./keys/web/tsa_host_key.pub ./keys/worker",
      "docker-compose up -d",
    ]
  }
}