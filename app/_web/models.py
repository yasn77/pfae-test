from app import db


class People(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String(25))
    last_name = db.Column(db.String(25))
    age = db.Column(db.Integer)
