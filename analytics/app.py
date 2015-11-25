from flask import Flask, render_template, jsonify, make_response
from pymongo import MongoClient
from bson import json_util
import json

app = Flask(__name__)
client = MongoClient()
db = client.log_database
collection = db.log


@app.route("/db_as_table")
def db_as_table():
    log_objects = []

    for log_object in collection.find():
        log_objects.append(log_object)

    print log_objects

    return render_template("db_as_table.html", log=log_objects)


@app.route("/admin/total_visitors")
def total_visitors():
    res = collection.distinct("ip_address")
    res = len(res)
    return jsonify({"count": res})


@app.route("/admin/total_registered_visitors")
def total_registered_visitors():
    res = collection.distinct("user_id", {"user_id": {"$nin": ["", None]}})
    res = len(res)
    return jsonify({"count": res})


@app.route("/admin/visits_by_users")
def count_visits():
    res = list(db.log.aggregate([
        {"$group": {"_id": "$ip_address", "count": {"$sum": 1}}}
    ]))
    return make_response(json.dumps(res))


@app.route("/admin/visits_by_registered_users")
def count_registered_visits():
    res = list(db.log.aggregate([
        {"$group": {"_id": "$user_id", "count": {"$sum": 1}}}
    ]))
    return make_response(json.dumps(res))


@app.route("/admin/daily_visits")
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


if __name__ == "__main__":
    app.run()
