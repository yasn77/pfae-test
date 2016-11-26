# PFAE Test
---

This repository contains configuration needed to build and run PFAE Test
platform and application.

### Getting started
Please have a look at the following README for more details:
 - [Terraform README](./terraform/README.md)
 - [Ansible README](./ansible/README.md)

In summary, run through Terraform to build the AWS instances and then run
Ansible to configure the instances.

### Direnv
The repository contains `.envrc` files that are used by [`direnv`](http://direnv.net/). Direnv can assit in setting up environment variables and Python virtualenv.
