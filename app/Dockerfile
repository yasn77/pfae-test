FROM alpine:latest
ENV INTERNAL_PORT 8080
ENV PFAE_CONFIG /pfae.cfg
EXPOSE $INTERNAL_PORT

RUN apk --update add py-gunicorn python py-pip py-psycopg2
COPY start.sh /start.sh
COPY pfae.cfg $PFAE_CONFIG
COPY _web /_web

WORKDIR /_web
RUN pip install -r requirements.txt

ENTRYPOINT /start.sh
