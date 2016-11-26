# PFAE Ansible
It is highly recommended that you use [direnv](http://direnv.net/). A `.envrc` exists that facilitates in setting up virtualenv and source enviroment variables used by both Terraform and Ansible.

The following environment variables are required to be set:

|Environment Variable|Description|
|--------------------|-----------|
|`AWS_SECRET_ACCESS_KEY`|AWS Secret Access Key|
|`AWS_ACCESS_KEY_ID`|AWS Access Key ID|
|`TF_VAR_access_key`|Set same as `AWS_ACCESS_KEY_ID`|
|`TF_VAR_secret_key`|Set Same as `AWS_ACCESS_KEY_ID`|
|`TF_VAR_sshpubkey_file`|Path to SSH private key (will be used to SSH in to EC2 Instances)|

If you use `direnv`, then these can be stored in `<REPO_ROOT>/.secrets` and will automatically be loaded and exported.

## Ansible Vault password file
Create a file that will contain the Ansible Vault password:
```shell
echo [VAULT_PASSWORD] > .vault_password
```
_Note: Replace `[VAULT_PASSWORD]` with the correct Ansible Vault password_

It is recommended to use virtualenv, if you use `direnv` this will automatically be created.

Ansible (and it's dependencies) can be installed using pip:
```shell
$ pip install -r requirements.txt
```

Also need to install Ansible Galaxy roles:
```shell
ansible-galaxy install -r galaxy-requirements.yml
```

To run Ansible:
```shell
ansible-playbook -u ubuntu --private-key ~yasser/.ssh/personal_ssh_key -i hosts/ --vault-password-file=.vault_password main.yml
```
