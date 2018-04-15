FROM node:9.7.0-alpine

#
# This label becomes available as meta-data on the running container. We can
# then use this label in the DataDogHQ log aggregation configuration to define
# which Docker services the DataDog agent should watch for logs.
#
LABEL me.dailyprime.service="web"

WORKDIR /var/www/dailyprime.me

#
# Copy over the node installation files and install the modules.
# --
# NOTE: Since we are not mounting the node_modules folder, you have to run
# "npm install" from within the container.
#
COPY ./package.json ./package-lock.json ./
RUN npm install

COPY ./ ./

#
# It is apparently best practice to not run the docker container as root.
# However, if I run it as "node", then I can't figure out how to bash-in and
# augment the node_modules (was getting a permission denied). The "sudo"
# command didn't seem to exist. So, I'm commenting this directive out while
# I actively develop the container. Then, when I'm ready to build it for
# deployment, I put it back in place.
# --
# NOTE: The node-alpine image comes pre-installed with the "node" user.
#
# USER node

CMD [ "node", "./server/index.js" ]
