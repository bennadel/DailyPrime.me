FROM nginx:1.13.9-alpine

#
# This label becomes available as meta-data on the running container. We can
# then use this label in the DataDogHQ log aggregation configuration to define
# which Docker services the DataDog agent should watch for logs.
#
LABEL me.dailyprime.service="proxy"

#
# The dhparams.pem file defines how OpenSSL performs the Diffie-Hellman (DH)
# key-exchange. I generated this file locally using:
# ---
# openssl dhparam -out dhparam.pem 4096
# ---
#
COPY ./dhparams.pem /etc/ssl/private/

#
# This defines the site configuration for the production nginx.
#
COPY ./default.conf /etc/nginx/conf.d/
