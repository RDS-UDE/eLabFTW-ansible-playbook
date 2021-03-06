Role Name
=========

This role installs an apache2 web server, configures SSL and starts the web server.
Configurations specific for eLabFTW can be found in the eLabFTW role.

It can either generate a certificate via Let's Encrypt (with certbot) or use a
certificate issued by DFN. Using a certificate from a different CA will
require some customization.

Requirements
------------

If you want to use a DFN certificate, you need to have access to a certificate and the
corresponding private key file. The private key can be generated by the script
`roles/base_config/templates/dfn_certificate_request.sh`. This script is copied to the
managed node when running the `base_config` role. It then needs to be manually executed.
This script provides you with a certificate request that you can use to apply
for a DFN certificate for your node.

The file `chain.pem` is the DFN certificate chain available at: https://info.pca.dfn.de/dfn-ca-global-g2/

Role Variables
--------------

This role is intended to be used with an apache2 web server. However, variables preparing
the addition of other web servers have already been added.
