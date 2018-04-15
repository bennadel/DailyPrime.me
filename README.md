
# DailyPrime.me

by [Ben Nadel][bennadel]

I created the [DailyPrime.me][dailyprime] website because I wanted to learn more about
running Docker and deploying containerized services. Over the last couple of months, it's
become clear that my lack of hands-on experience with servers is hampering my ability to
express myself creatively in the web-space. And so, I have set out to remedy that
knowledge-gap. The Daily Prime does not, in and of itself, have anything to do with
Docker - it is merely the test harness within which I will be doing much of my learning.

I am performing this experiment in the public eye in case anyone cares to contribute; or,
to provide feedback and advice on how I am approaching the problem. When it comes to
Docker, containerization, and server management, I am truly a "n00b".

## Services

### `proxy`

This is the nginx ingress for the **local** web application. It sits in front of the
`web` service, which is our Node.js process listening on port `:8080`.

> **ASIDE**: When setting up the production server, I briefly used this `proxy` service
> as the "production" proxy while I was provisioning the SSL certificate from the
> LetsEncrypt cerbot (see `./scripts` folder).

### `proxy-prod`

This is the nginx ingress for the **production** web application. It sits in front of the
`web` service (just like `proxy`). But, it exposes both `:80` and `:443` ports.

### `statsd-mock`

This is the StatsD server for the **local** development environment. It does not provide
any StatsD functionality - it simply exposes port `:8125` and logs UDP messages to the
console where they can be observed.

> **ASIDE**: In production, I am using the containerized DataDog agent provided by
> DataDog, which exposes DogStatsD functionality (see the `docker-compose.prod.yml` file
> for `dd_agent`).

### `web`

I am the node.js web application that actual codes-up the app logic.

## Development Notes

[My original blog post on this topic][bennadel-3419] outlines how I got this server up
and running. However, a few notes on things that have changed:

* I have a `.env` file that is _not committed to git_ that contains secrets. This `.env`
  file is automatically consumed by Docker Compose, and exposes `${VAR}` variables that
  I can use in my `docker-compose.yml` file(s). I have committed `.env.template` which 
  demonstrates which variables are configured.

* The `proxy-prod/dhparams.pem` file was generated using the following bash command:
  
  ```sh
  openssl dhparam -out dhparam.pem 4096
  ``` 


[bennadel]: https://www.bennadel.com
[bennadel-3419]: https://www.bennadel.com/blog/3419-from-noob-to-docker-on-digitalocean-with-nginx-node-js-datadog-logs-dogstatsd-and-letsencrypt-ssl-certificates.htm
[dailyprime]: https://dailyprime.me
[docker]: https://www.docker.com
