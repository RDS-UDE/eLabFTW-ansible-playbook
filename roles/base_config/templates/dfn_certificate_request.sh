#!/bin/bash
echo "This script creates a private key and a certificate request for a DFN certificate application."
echo "WARNING: To allow webservers to reboot without providing a password, this key is generated without a password."
# NOTE: If you want to use multiple URLs for this server, e.g. elabftw.example.com and elabftw.long-example.com
# you need to add the following line to the openssl call in the following line.
# -addext='subjectAltName=DNS:{{ inventory_hostname | replace(".example.com", ".long-example.com") }}'
openssl req -newkey rsa:4096 -keyout {{ inventory_hostname }}.key.pem -out request.{{ inventory_hostname }}.pem -subj  '/C={ cert_country }/ST={ cert_country }/L={ cert_locality }/O={ cert_organization }/OU={ cert_organizational_unit }/CN={{ inventory_hostname }}/emailAddress={ cert_email }' -nodes
sleep 1
requestPass=$(openssl rand -base64 14 | cut -d '=' -f 1)
echo "Possible password for den request/revoke application"
echo $requestPass
sleep 1
echo "With the request and password, apply for a certificate on the following website:"
echo "https://pki.pca.dfn.de/dfn-ca-global-g2/cgi-bin/pub/pki?cmd=pkcs10_req;id=1;menu_item=2"
echo "To validate a certificate use the following command:"
echo "cat request.{{ inventory_hostname }}.pem | openssl req -text -noout"
