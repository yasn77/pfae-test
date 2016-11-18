#!/bin/sh

pip install -r /_web/requirements.txt

/usr/bin/gunicorn --bind 0.0.0.0:$INTERNAL_PORT --chdir /_web app:app
