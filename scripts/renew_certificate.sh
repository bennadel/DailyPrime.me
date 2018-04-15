#!/bin/bash
/usr/bin/docker run -it --rm --name letsencrypt \
	-v "/etc/letsencrypt:/etc/letsencrypt" \
	quay.io/letsencrypt/letsencrypt:latest \
		renew &&

#
# When a certificate is renewed, the nginx proxy container needs to be restarted in order
# to pick up the new certificates. However, according to the documentation:
#
# > certbot renew exit status will only be 1 if a renewal attempt failed. This means
# > certbot renew exit status will be 0 if no cert needs to be updated. If you write a
# > custom script and expect to run a command only after a cert was actually renewed you
# > will need to use the --post-hook since the exit status will be 0 both on successful
# > renewal and when renewal is not necessary.
#
# However, since the certbot is running inside a container, it doesn't have access to
# the nginx process, at least as far as I know - I'm a Docker noob. As such, I'm going to
# have this script restart nginx no matter what the outcome. And, since this will only
# happen occasionally, and nginx restarts really fast, this will only lead to a tiny bit
# of down time.
#
# NOTE: We are using absolute paths to the docker-compose command and to the config file
# because we can't depend on the PATH or the context of the crontab execution. As such,
# this makes it very clear exactly what will be executed.
#
/usr/local/bin/docker-compose -f /root/docker-compose.yml restart proxy &&

#
# I sent a DogStatsD metric to DataDog, recording the successful completion of the
# certificate renewal.
#
/usr/local/bin/docker-compose -f /root/docker-compose.yml exec dd_agent bash -c "echo 'script.renew_certificate:1|c' > /dev/udp/127.0.0.1/8125"
