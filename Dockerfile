FROM alpine:latest

# We need the following:
# - git-daemon, because that gets us the git-http-backend CGI script
# - fcgiwrap, because that is how nginx does CGI
# - spawn-fcgi, to launch fcgiwrap and to create the unix socket
# - nginx, because it is our frontend. We also need to change the permission
#     if we want to be able to use a non-root user. 777 it not the most elegant
#     solution, but it works.
# - tini, so we can have proper PID 1 process
RUN apk add --no-cache --update nginx && \
    apk add --no-cache --update git-daemon && \
    apk add --no-cache --update fcgiwrap && \
    apk add --no-cache --update spawn-fcgi && \
    apk add --no-cache --update tini && \
    chmod -R 777 /var/lib/nginx /var/log/nginx

COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod 744 /etc/nginx/nginx.conf

# The container listens on port 80, map as needed
EXPOSE 80
# /git where the repositories will be stored.
# htpasswd is the file with our user and their (hashed) passwords.
# Both should be mounted from the host (or a volume container).
VOLUME ["/git", "/etc/nginx/htpasswd"]

LABEL maintainer="Claudio Yanes me@claudio4.com"

# launch fcgiwrap via spawn-fcgi; launch nginx in the foreground
# so the container doesn't die on us.
CMD ["/sbin/tini", "--", "/bin/sh", "-c", "spawn-fcgi -s /tmp/fcgi.sock /usr/bin/fcgiwrap && nginx -g \"daemon off;\" -e stderr -p /tmp"]
