# eLabFTW Ansible Playbook

This repository contains an Ansible project that allows an installation of [eLabFTW](https://github.com/elabftw/elabftw) without docker.
Please be aware that if you choose this approach over the docker installation, you should have a good reason to do this.

While we cannot guarantee that this project will always be up-to-date with the most recent update of eLabFTW, we will strive to keep this repository up to date.
You can find a complete list of change notes in the [changelog](CHANGELOG.md).

## Content
This project contains three major directories that should be familiar to any Ansible user:

- The folder `playbooks` contains, well, the playbook, which defines which roles are executed and in what order.
- The folder `roles` contains collections of tasks that are required for the installation. Currently, the four roles used by the playbook are a basic configuration of an Ansible-managed node, installation and configuration for apache and mySQL, and finally the installation of eLab itself.
- The folder `inventories` contains a folder structure that describes a set of managed nodes. Nodes themselves are defined in the files `hosts.yaml`. Variables for a group of hosts (i.e. all nodes that get an eLabFTW installation) are stored in the `group_vars` folder. Variables that are specific to a certain host (like passwords, etc.) are stored in the `host_vars` folder.


## Requirements

To run this playbook, you need two machines (e.g. VMs), one acting as Ansible **control node** and one as **managed node**.
We strongly recommend making snapshots of your VM along the way.

### Control Node
This machine executes the playbook. We assume that the user on this machine is called `ansible-master` and that there is an SSH public key file `/home/ansible-master/.ssh/id_rsa.pub`.
The first role of the playbook sets up the managed node (see below) so that this key is used by Ansible to connect to the managed node.
For this to work you need to provide the IP-address of the control node in the file [`conf_firewall.yml`](roles/base_config/tasks/conf_firewall.yml).

Further, on the control node you need to install python3 and Ansible 4.0.
We recommend installing Ansible using a package management system like `pip` or `conda`.

    pip install ansible

### Managed Node
This is the host on which you want to install eLabFTW.
Our playbook supports Ubuntu 20.04 and 18.04 as target operating system for the managed node, though we recommend using 20.04.
Apart from that, this machine needs python3 and a user that can access the machine via SSH.
By default, this user is also named `ansible-master`, but you can change the name of the user Ansible will use in the `hosts.yaml`.


## Usage

Please be advised that this eLabFTW Playbook cannot be used out-of-the-box but requires tailoring to your local setup.
There are several major adjustments that are necessary:

1. Define a host and replace all occurrences of the dummy host.
2. Fill out the required variables, IP-addresses etc.
3. Encrypt the files storing secret information using ansible-vault.
4. Run the `base_config` role.
  - If you want to use a certificate issued e.g. by the DFN-PKI you need to request that certificate.
    This playbook places a script on the managed node that can help generating that.
  - Wait for the certificate file to arrive and place it (and its vault-encrypted private key) in the folder [roles/webserver/files/ssl/](roles/webserver/files/ssl/).
    For the Let's Encrypt certificate this should work without any waiting.
5. Add the remaining step in the playbook file by uncommenting them.
6. Run the whole Playbook .

### Defining a host
To provide a guiding structure, we used the host name `elabftw.example.com` throughout this playbook.
For your own managed node, replace this name with the fully qualified domain name (FQDN) of your node.
Most prominently, you need to edit the `hosts.yaml`, rename the folder contained in the `host_vars`, adapt the names of the cert and key files in the `apache2.yml` in the `host_vars`, and rename the SSL key and cert file.

### Fill out variables
Fill out the empty values in the files in the `group_vars` and `host_vars` folders.
There you can also configure your installation e.g. if you want to use a DFN certificate or use Let's Encrypt for SLL.

Throughout the playbook, there are several variables you need to provide for this playbook to run.
These are marked with TODO comments and you should find them using

    grep -r "TODO" .


### Encrypt files
Some files in this setup contain secret information that should be kept private at all times.
The solution offered by Ansible for this is called [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html), which allows you to encrypt files in the playbook and Ansible will decrypt them when executed (if you provide the right vault password).
Most notably these are the SSL `.key.pem` file and the file `mysql.yml` in the `host_vars`, but you might decide to vault additional files.

You can encrypt [existing files](https://docs.ansible.com/ansible/latest/user_guide/vault.html#encrypting-existing-files) using
```
ansible-vault encrypt foo.yml
```
and edit them later using
```
ansible-vault edit foo.yml
```

Since you need to pass this password on every run of the playbook, we recommend using a password manager for this.

Also, be sure to never commit unvaulted secrets to your git repository as these can be restored from your git history!


