# elabftw_install

This role installs a specified version of eLabFTW, configures and deploys it.
It can be used to update to a newer version of eLabFTW by updating the `elab_version`
parameter in the group vars or host vars. This might require additional adjustments
to other roles and tasks, so proceed with caution. Especially major releases should
be handled with extreme caution.

Note that this role interacts with the results set up by the previously executed roles.
For example this eLabFTW role contains an SSL config file that is tailored to eLabFTW.

## Requirements

For this role to work, a minimal set of parameters has to be supplied in
the group and host vars. These include the database password and secret,
which should be stored in a vaulted (encrypted) file.


## Role Variables

The PHP upload size and POST size are set in the defaults of the role.
These govern the size limit of files that can be uploaded to eLabFTW.
By default, in this notebook, the upload limit is 20MB per file.

Should this be changed, add a corresponding key to the `group_vars` or `host_vars`,
depending on which nodes should be affected.


### Group Vars
There are three important `group_vars` for this role:

- `elab_version: 4.0.11` The version of eLabFTW that is to be installed. You can find these on the
  [releases page](https://github.com/elabftw/elabftw/releases) of eLabFTW.
- `php_version: '8.0'` This version depends on the requirements of eLabFTW. Currently (2021-08-16),
  eLabFTW 3.x.x requires PHP 7.4 while eLabFTW 4.x.x requires PHP 8.0.
- `php_packages: [...] ` This dictionary maps a `php_version` to the packages required by eLabFTW
  for said version. Should a new version of PHP be used you need to extend this dictionary.


### Host Vars
No specific host-level variables are used by this role.

However, the `db_*` variables from the `mysql` role are required by this role.
Most of these are fixed for eLabFTW (`db_host`, `db_port`, `db_name`, `db_user`)
and you should not need to change these.
However, you need to set the variables `db_pass` and `db_secret_key` in the
`host_config` of you target node. Since these are secrets, make sure to store
them in a vaulted (encrypted) file.


## Dependencies

This role assumes, that the roles `base_config`, `webserver`, and `mysql` have already been run.
