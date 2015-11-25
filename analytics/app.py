from functools import wraps

from flask import Flask, render_template, jsonify, make_response, request
from pymongo import MongoClient
from bson import json_util
import json

app = Flask(__name__)
client = MongoClient()
db = client.log_database
collection = db.log


def add_response_headers(headers={}):
    """This decorator adds the headers passed in to the response"""

    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            resp = make_response(f(*args, **kwargs))
            h = resp.headers
            for header, value in headers.items():
                h[header] = value
            return resp

        return decorated_function

    return decorator


def send_json(f):
    @wraps(f)
    @add_response_headers({'Content-Type': 'application/json'})
    def decorated_function(*args, **kwargs):
        return f(*args, **kwargs)

    return decorated_function


@app.route("/db_as_table")
def db_as_table():
    log_objects = []

    for log_object in collection.find():
        log_objects.append(log_object)

    print log_objects

    return render_template("db_as_table.html", log=log_objects)


@app.route("/admin/total_visitors")
@send_json
def total_visitors():
    res = collection.distinct("ip_address")
    res = len(res)
    return jsonify({"count": res})


@app.route("/admin/total_registered_visitors")
@send_json
def total_registered_visitors():
    res = collection.distinct("user_id", {"user_id": {"$nin": ["", None]}})
    res = len(res)
    return jsonify({"count": res})


@app.route("/admin/visits_by_users")
@send_json
def count_visits():
    res = list(db.log.aggregate([
        {"$group": {"_id": "$ip_address", "count": {"$sum": 1}}}
    ]))
    return make_response(json.dumps(res))


@app.route("/admin/visits_by_registered_users")
@send_json
def count_registered_visits():
    res = list(db.log.aggregate([
        {"$group": {"_id": "$user_id", "count": {"$sum": 1}}}
    ]))
    return make_response(json.dumps(res))


@app.route("/admin/daily_visits")
@send_json
def daily_visits():
    res = list(db.log.aggregate([
        {
            "$group":
                {
                    "_id":
                        {
                            "date": "$log_date"
                        },
                    "count":
                        {
                            "$sum": 1
                        }
                }
        }
    ]))
    return make_response(json.dumps(res, default=json_util.default))


@app.route("/admin/daily_registered_visits")
@send_json
def daily_registered_visits():
    res = list(db.log.aggregate([
        {
            "$match":
                {
                    "user_id":
                        {
                            "$gt": 0
                        }
                }
        },
        {
            "$group":
                {
                    "_id":
                        {
                            "date": "$log_date"
                        },
                    "count":
                        {
                            "$sum": 1
                        }
                }
        }
    ]))
    return make_response(json.dumps(res, default=json_util.default))


@app.route("/business/total_users_for_business")
def total_users_for_business():
    business_id = request.args.get("business_id")
    if business_id:
        count = db.log.find({"business_id": int(business_id)}).count()
        resp = make_response(json.dumps({"count": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/total_registered_users_for_business")
def total_registered_users_for_business():
    business_id = request.args.get("business_id")
    if business_id:
        count = db.log.find(
            {
                "business_id": int(business_id),
                "user_id": {
                    "$nin": ["", None]
                }
            }).count()
        resp = make_response(json.dumps({"count": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/total_registered_users_checking_your_workers")
def total_registered_users_checking_your_workers():
    business_id = int(request.args.get("business_id"))
    workers = request.args.get("workers")
    workers = workers.split(",")
    workers_for_query = []
    for w in workers:
        try:
            workers_for_query.append(int(w))
        except ValueError:
            pass
    if business_id and len(workers) > 0:
        count = db.log.find(
            {
                "business_id": business_id,
                "user_id": {
                    "$nin": ["", None]
                },
                "worker_id": {
                    "$in": workers_for_query
                }
            }).count()
        print count
        resp = make_response(json.dumps({"count": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/daily_registered_visits")
def business_daily_registered_visits():
    business_id = int(request.args.get("business_id"))
    if business_id:
        res = list(db.log.aggregate([
            {
                "$match":
                    {
                        "user_id":
                            {
                                "$gt": 0
                            },
                        "business_id": business_id
                    }
            },
            {
                "$group":
                    {
                        "_id":
                            {
                                "date": "$log_date"
                            },
                        "count":
                            {
                                "$sum": 1
                            }
                    }
            }
        ]))
        resp = make_response(json.dumps({"results": res}, default=json_util.default))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


if __name__ == "__main__":
    app.run()
