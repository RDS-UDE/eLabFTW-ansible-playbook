# Base Config

This role prepares a node to become a managed node and performs security and maintenance tasks.
This includes copying ssh keys, perform system updates, configure sshd and the firewall etc.

## Requirements

This role assumes that the user executing the playbook on the control node is named `ansible-master`
and that an SSH public key `/home/ansible-master/.ssh/id_rsa.pub` exists on the control node.
