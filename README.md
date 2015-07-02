# Vagrant file for Rbbt

## Instructions

* Install [Vagrant](http://www.vagrantup.com)
* Clone repo
* `vagrant up`

To retrieve special provisions for apps etc. check the branches. You may use
the `bin/build_provision_sh` to build a provision script that you can use in
Docker (see example)

```bash
bin/build_provision_sh -w Translation,Sequence > mydocker_image/provision.sh
cp Dockerfile mydocker_image/
docker build -t <repo:tag> mydocker_image/
```

The `bin/build_provision_sh` script is documented, try the `-h` flag for
options, these include options for specifying which workflows to bootstrap, or 
configuring remote servers for resources and for workflows.
