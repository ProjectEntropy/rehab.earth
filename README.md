# Abstraction

Sandpit for: DigitalOcean, Terrform, Docker, Concourse, MailCow, Chef, Inspec

# Inception

Ensure variables are available according to your shell of choice.
```sh
# Personal
export user=""
export TF_VAR_project=""
export TF_VAR_tz=""
# Generated from Digital Ocean
export TF_VAR_ssh_fingerprint=""
export TF_VAR_do_token=""
# Something like... ssh-keygen -t rsa -f ~/.ssh/${user}.${project}_rsa
export TF_VAR_pub_key="$HOME/.ssh/${user}.${project}_rsa.pub"
export TF_VAR_pvt_key="$HOME/.ssh/${user}.${project}_rsa"
```

Running with Terraform v0.8.4.
```sh
pushd terraform
terraform plan
```

After Sanity check.
```sh
terraform apply
popd
```

# Tests

```sh
pushd cookbooks/mailcow
bundle install
bundle exec kitchen test
popd
```

# Realisation

Connection to hosts is via tunnels until VNP is configured
```sh
ssh -v -L localhost:8080:${CONCOURSE_INTERNA_IP}:8080 -i ~/.ssh/mr.t_rsa root@${BASTION_EXTERNAL_IP}
```

# Termination

```sh
pushd terraform
terraform plan -destroy
```

After sanity check.
```sh
terraform destroy
popd
```
