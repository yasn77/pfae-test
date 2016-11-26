#!/bin/sh

/usr/bin/gunicorn --bind 0.0.0.0:$INTERNAL_PORT --chdir /_web app:app
