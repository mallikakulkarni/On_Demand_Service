from functools import wraps, update_wrapper
import datetime
from flask import Flask, render_template, jsonify, make_response, request, current_app
from pymongo import MongoClient
from bson import json_util
import json

app = Flask(__name__)
client = MongoClient()
db = client.log_database
collection = db.log


def encode_time(value):
    return datetime.datetime.combine(value, datetime.datetime.min.time())


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


def crossdomain(origin=None, methods=None, headers=None,
                max_age=21600, attach_to_all=True,
                automatic_options=True):
    if methods is not None:
        methods = ', '.join(sorted(x.upper() for x in methods))
    if headers is not None and not isinstance(headers, basestring):
        headers = ', '.join(x.upper() for x in headers)
    if not isinstance(origin, basestring):
        origin = ', '.join(origin)
    if isinstance(max_age, datetime.timedelta):
        max_age = max_age.total_seconds()

    def get_methods():
        if methods is not None:
            return methods

        options_resp = current_app.make_default_options_response()
        return options_resp.headers['allow']

    def decorator(f):
        def wrapped_function(*args, **kwargs):
            if automatic_options and request.method == 'OPTIONS':
                resp = current_app.make_default_options_response()
            else:
                resp = make_response(f(*args, **kwargs))
            if not attach_to_all and request.method != 'OPTIONS':
                return resp

            h = resp.headers

            h['Access-Control-Allow-Origin'] = "*"
            h['Access-Control-Allow-Methods'] = get_methods()
            h['Access-Control-Max-Age'] = str(max_age)
            if headers is not None:
                h['Access-Control-Allow-Headers'] = headers
            return resp

        f.provide_automatic_options = False
        return update_wrapper(wrapped_function, f)

    return decorator


@app.route("/db_as_table")
@crossdomain(origin='*')
def db_as_table():
    log_objects = []

    for log_object in collection.find():
        log_objects.append(log_object)

    print log_objects

    return render_template("db_as_table.html", log=log_objects)


@app.route("/admin/total_visitors")
@send_json
@crossdomain(origin='*')
def total_visitors():
    res = collection.distinct("ip_address")
    res = len(res)
    return jsonify({"result": res})


@app.route("/admin/total_registered_visitors")
@send_json
@crossdomain(origin='*')
def total_registered_visitors():
    res = collection.distinct("user_id", {"user_id": {"$nin": ["", None]}})
    res = len(res)
    return jsonify({"result": res})


@app.route("/admin/visits_by_users")
@send_json
@crossdomain(origin='*')
def count_visits():
    res = list(db.log.aggregate([
        {"$group": {"_id": "$ip_address", "count": {"$sum": 1}}}
    ]))
    avg = c = total = 0
    for r in res:
        c += 1
        total += r['count']
    if c != 0:
        avg = total / c
    return make_response(json.dumps({"result": avg}))


@app.route("/admin/visits_by_registered_users")
@send_json
@crossdomain(origin='*')
def count_registered_visits():
    res = list(db.log.aggregate([
        {
            "$match": {
                "user_id":
                    {
                        "$gt": 0
                    }
            }
        },
        {
            "$group":
                {
                    "_id": "$user_id",
                    "count":
                        {
                            "$sum": 1
                        }
                }
        }
    ]))
    avg = c = total = 0
    for r in res:
        c += 1
        total += r['count']
    if c != 0:
        avg = total / c
    return make_response(json.dumps({"result": avg}))


@app.route("/admin/daily_visits")
@send_json
@crossdomain(origin='*')
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
    return make_response(json.dumps({"result": res}, default=json_util.default))


@app.route("/admin/daily_registered_visits")
@send_json
@crossdomain(origin='*')
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
    return make_response(json.dumps({"result": res}, default=json_util.default))


@app.route("/business/total_users_for_business")
@crossdomain(origin='*')
def total_users_for_business():
    business_id = request.args.get("business_id")
    if business_id:
        count = db.log.find({"business_id": int(business_id)}).count()
        resp = make_response(json.dumps({"result": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/total_registered_users_for_business")
@crossdomain(origin='*')
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
        resp = make_response(json.dumps({"result": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/total_registered_users_checking_your_workers")
@crossdomain(origin='*')
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
        resp = make_response(json.dumps({"result": count}))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/business/daily_registered_visits")
@crossdomain(origin='*')
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
        resp = make_response(json.dumps({"result": res}, default=json_util.default))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/worker/total_registered_visits")
@crossdomain(origin='*')
def total_registered_visits():
    try:
        worker_id = int(request.args.get("worker_id"))
    except TypeError:
        return render_template("error.html"), 400
    if worker_id:
        count = db.log.find(
            {
                "worker_id": worker_id,
                "user_id": {
                    "$nin": ["", None]
                },
                "page_name": "worker",
                "action": "page_load"
            }
        ).count()
        resp = make_response(json.dumps({"result": count}, default=json_util.default))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/worker/total_registered_clicks")
@crossdomain(origin='*')
def total_registered_clicks():
    worker_id = int(request.args.get("worker_id"))
    if worker_id:
        count = db.log.find(
            {
                "worker_id": worker_id,
                "user_id": {
                    "$nin": ["", None]
                },
                "action": "click"
            }
        ).count()
        resp = make_response(json.dumps({"result": count}, default=json_util.default))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/worker/daily_registered_visits")
@crossdomain(origin='*')
def worker_daily_registered_visits():
    worker_id = int(request.args.get("worker_id"))
    if worker_id:
        res = list(db.log.aggregate([
            {
                "$match":
                    {
                        "user_id":
                            {
                                "$gt": 0
                            },
                        "worker_id": worker_id,
                        "page_name": "worker",
                        "action": "page_load"
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
        resp = make_response(json.dumps({"result": res}, default=json_util.default))
        resp.headers['Content-Type'] = 'application/json'
        return resp
    else:
        return render_template("error.html"), 400


@app.route("/log/", methods=['POST', 'OPTIONS'])
@crossdomain(origin="*")
def log():
    d = request.form
    user_id = d.get('userID', "")
    worker_id = d.get('workerID', "")
    business_id = d.get('businessID', "")
    search_term = d.get('searchTerm', "")
    page_name = d.get('pageName', "")
    action = d.get('action', "")
    user_agent = request.headers.get('User-Agent')
    ip_address = d.get("ipAddress", "")
    referrer = d.get("referrer", "")
    l = {
        "log_date": encode_time(datetime.datetime.now()),
        "log_timestamp": datetime.datetime.now(),
        "user_id": user_id,
        "worker_id": worker_id,
        "business_id": business_id,
        "search_term": search_term,
        "page_name": page_name,
        "action": action,
        "user_agent": user_agent,
        "ip_address": ip_address,
        "referrer": referrer
    }
    db.log.insert_one(l)

    return make_response(json.dumps({"done": True}, default=json_util.default))


if __name__ == "__main__":
    app.run()
