# Simple Nginx Site

![Travis CI Status](https://travis-ci.org/jesseadams/simple_nginx_site.svg?branch=master)

## Description

Installs a very simple nginx configuration to deploy a static index.html file

## Local Development

Upon pushing a new change the build will be validated in TravisCI.

### Testing

```shell
chef exec berks install
chef exec foodcritic . --exclude test
chef exec cookstyle
chef exec rspec
chef exec kitchen test
```

## Building a new artifact

Use packer to generate a new AMI.

```shell
cd packer
packer build ami.json
```

Update the AMI to the latest in ami.txt.

## Deploying the latest artifact to AWS

Use terraform to deploy the latest AMI to AWS.

```shell
cd terraform
terraform plan -var "ami=`cat ../packer/ami.txt`"
terraform apply -var "ami=`cat ../packer/ami.txt`"
```
