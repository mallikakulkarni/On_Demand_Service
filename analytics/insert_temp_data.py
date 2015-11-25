#!/usr/bin/python
import sys
import datetime
from pymongo import MongoClient
import random
import string
from migration_transformer import MigrationTransformer

client = MongoClient()
db = client.log_database
db.add_son_manipulator(MigrationTransformer())
collection = db.log

print "Number of args: ", len(sys.argv)
print "Args list: ", str(sys.argv)

end_date = days = no_of_businesses = no_of_workers = no_of_users = frequency = None


def get_random_search_term():
    i = random.randint(0, 9)
    if i % 2 == 0:
        return ''.join(random.choice(string.ascii_lowercase) for j in range(5))
    return ""


PAGES = ['home', 'business', 'worker', 'worker_schedule', 'book']


def get_random_page_name():
    i = random.randint(0, 4)
    return PAGES[i]


def encode_time(value):
    return datetime.datetime.combine(value, datetime.datetime.min.time())


try:
    start_date = datetime.datetime.strptime(sys.argv[1], "%H:%M:%S-%m-%d-%Y")
    end_date = sys.argv[2]
    if end_date == 'now':
        end_date = datetime.datetime.now()
    else:
        end_date = datetime.datetime.strptime(end_date, "%H:%M:%S-%m-%d-%Y")
    no_of_businesses = int(sys.argv[3])
    no_of_workers = int(sys.argv[4])
    no_of_users = int(sys.argv[5])
    frequency = int(sys.argv[6])
    # raise IndexError
    temp_date = start_date
    while temp_date <= end_date:
        # add user log for number of users
        for user in range(1, no_of_users + 1):
            for business in range(1, no_of_businesses + 1):
                for worker in range(1, no_of_users + 1):
                    # add to log
                    page_name = get_random_page_name()
                    if page_name == PAGES[0]:
                        search_term = get_random_search_term()
                    else:
                        search_term = ""
                    l = {
                        "log_date": encode_time(temp_date.date()),
                        "log_timestamp": temp_date,
                        "user_id": user,
                        "worker_id": worker,
                        "business_id": business,
                        "search_term": search_term,
                        "page_name": page_name,
                        "action": "page_load",
                        "user_agent": "",
                        "ip_address": "10.1.0.%s" % user,
                        "referrer": ""
                    }
                    collection.insert_one(l)
                    temp_date += datetime.timedelta(seconds=frequency)

except (IndexError, ValueError) as e:
    print e
    print "Incorrect usage."
    print "Proper usage is: "
    print "python insert_temp_data.py <start_date> <end_date> <no_of_businesses> <no_of_workers> <no_of_users> <frequency>"
    print "date format = [now, hh:mm:ss MM-DD-yyyy]"
    print "Frequency values = <value> seconds"
