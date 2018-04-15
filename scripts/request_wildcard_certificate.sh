#!/bin/bash

#
# /etc/letsencrypt
# WHAT: This is the default configuration directory. This is where certbot will store all
# generated keys and issues certificates.
#
# /var/lib/letsencrypt
# WHAT: This is default working directory.
#
# certonly
# WHAT: This certbot subcommand tells certbot to obtain the certificate but not not 
# install it. We don't need to install it because we will be linking directly to the 
# generated certificate files from within our subsequent nginx configuration.
#
# -d
# WHAT: Defines one of the domains to be used in the certificate. We can have up to 100
# domains in a single certificate. In this case, we're obtaining a wildcard-subdomain
# certificate (which was just made possible!) in addition to the base domain.
#
# --manual
# WHAT: Tells certbot that we are going to use the "manual" plug-in, which means we will
# require interactive instructions for passing the authentication challenge. In this case
# (using DNS), we're going to need to know which DNS TXT entires to create in our domain
# name servers.
#
# --preferred-challenges dns
# WHAT: Defines which of the authentication challenges we want to implement with our
# manual configuration steps.
#
# --server https://acme-v02.api.letsencrypt.org/directory
# WHAT: The client end-point / resource that provides the actual certificates. The "v02"
# end-point is the only one capable of providing wildcard SSL certificates at this time,
# (ex, *.example.com).
#
docker run -it --rm --name letsencrypt \
	-v "/etc/letsencrypt:/etc/letsencrypt" \
	-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	quay.io/letsencrypt/letsencrypt:latest \
		certonly \
		-d dailyprime.me \
		-d *.dailyprime.me \
		--manual \
		--preferred-challenges dns \
		--server https://acme-v02.api.letsencrypt.org/directory
