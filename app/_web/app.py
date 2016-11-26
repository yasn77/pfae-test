import hashlib
import os
import json
import requests
from pymongo import MongoClient
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)

from models import People

app.config['CONFIG_SHA1'] = ''
app.config['PEOPLE_NAMES'] = list()


def _check_sha1(file):
    BLOCKSIZE = 65536
    sha1 = hashlib.sha1()
    with open(file, 'rb') as f:
        buf = f.read(BLOCKSIZE)
        while len(buf) > 0:
            sha1.update(buf)
            buf = f.read(BLOCKSIZE)
    return sha1.hexdigest()


def _check_config_file(file):
    sha1 = _check_sha1(file)
    if sha1 != app.config['CONFIG_SHA1']:
        app.config['CONFIG_SHA1'] = sha1
        update_config()


def _get_names():
    names_url = 'http://uinames.com/api/?amount=10&ext&region=United%20States'
    resp = requests.get(names_url)
    return [{'first_name': entry['name'], 'last_name': entry['surname'],
            'age': entry['age']} for entry in resp.json()]


def _create_db():
    db.create_all()
    db.session.commit()


def update_config():
    app.config['PEOPLE_NAMES'] = _get_names()
    app.config.from_envvar('PFAE_CONFIG', silent=True)


@app.route('/')
def slash():
    _check_config_file(os.environ['PFAE_CONFIG'])
    return json.dumps({}), 200


@app.route('/test')
def add_to_sql():
    _check_config_file(os.environ['PFAE_CONFIG'])
    _create_db()
    db.engine.execute(People.__table__.insert(), app.config['PEOPLE_NAMES'])
    return '', 200


@app.route('/transfer')
def transfer_to_nosql():
    _check_config_file(os.environ['PFAE_CONFIG'])
    mongo = MongoClient('mongodb://{}:{}@{}'.format(
        app.config['MONGO_USER'],
        app.config['MONGO_PASSWORD'],
        app.config['MONGO_HOST']))
    db = mongo.pfae
    mongo_people = db.people
    people = ([{'first_name': row.first_name,
                'last_name': row.last_name,
                'age': row.age} for row in People.query.all()])
    mongo_people.insert_many(people)
    return '', 200


@app.route('/count')
def count_records():
    _check_config_file(os.environ['PFAE_CONFIG'])
    mongo = MongoClient('mongodb://{}:{}@{}'.format(
        app.config['MONGO_USER'],
        app.config['MONGO_PASSWORD'],
        app.config['MONGO_HOST']))
    db = mongo.pfae
    people = db.people
    return json.dumps({'people_count': people.count()}), 200

if __name__ == '__main__':
    update_config()
    app.run()
