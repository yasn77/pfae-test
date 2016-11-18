FROM alpine:latest
ENV INTERNAL_PORT 8080
EXPOSE $INTERNAL_PORT

RUN apk --update add py-gunicorn python py-pip
COPY start.sh /start.sh
COPY _web /_web

WORKDIR /_web

ENTRYPOINT /start.sh
