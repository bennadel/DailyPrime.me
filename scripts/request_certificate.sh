#!/bin/bash

#
# /etc/letsencrypt
# WHAT: This is the default configuration directory. This is where certbot will store all
# generated keys and issues certificates.
#
# /var/lib/letsencrypt
# WHAT: This is default working directory.
#
# /tmp/letsencrypt/www
# WHAT: This is the webroot into which the authentication challenge files will be placed.
# We're going to map this file to the root of the "/.well-known/acme-challenge" location
# in our nginx configuration.
#
# certonly
# WHAT: This certbot subcommand tells certbot to obtain the certificate but not not 
# install it. We don't need to install it because we will be linking directly to the 
# generated certificate files from within our subsequent nginx configuration.
#
# -d
# WHAT: Defines one of the domains to be used in the certificate. We can have up to 100
# domains in a single certificate.
#
# --authenticator webroot
# WHAT: We are going to use the webroot plug-in for the LetsEncrypt authentication
# challenge. This means that we're going to satisfy the ownership requirement by placing
# files in a public folder on our web-server.
#
# --webroot-path /var/www
# WHAT: This is the folder that we're going to use as the web-root in our "webroot"
# plug-in authentication challenge. Notice that we are mapping this folder to the 
# "/tmp/letsencrypt/www" folder on the host machine (which will subsequently be included
# in our nginx configuration).
#
# --renew-by-default
# WHAT: Re-issue the certificate even if it already exists and is not expiring.
#
# --server https://acme-v01.api.letsencrypt.org/directory
# WHAT: ??? The resource that provides the actual certificate ???
#
docker run -it --rm --name letsencrypt \
	-v "/etc/letsencrypt:/etc/letsencrypt" \
	-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	-v "/tmp/letsencrypt/www:/var/www" \
	quay.io/letsencrypt/letsencrypt:latest \
		certonly \
		-d dailyprime.me \
		-d www.dailyprime.me \
		--authenticator webroot \
		--webroot-path /var/www \
		--renew-by-default \
		--server https://acme-v01.api.letsencrypt.org/directory
