var express = require('express');
var router = express.Router();
var db = require('./db');
var createConnection = db.createConnection;
var async = require("async");


/* GET home page. */
router.post('/bsignup', function(req, res, next) {
    checkBusinessExists(req.body.email, function(exists){
        if (exists) {
            res.render('login');
        } else {
            businesssignup(req.body, function(id) {
                res.render('businesshomepage', {id: id});
            });
        }
    });
});

router.get('/bsignup', function(req, res) {
   res.send('Got it');
});

router.post('/blogin', function(req, res) {
    checkBusinessLogin(req.body.sm_id, req.body.password, function(response) {
        if (response === null) {
            res.render('incorrectlogin');
        } else {
            res.render('businesshomepage', {name: response.name, id: response.sm_id});
        }
    })
});

router.get('/pendingjobs', function(req, res) {
    getPendingJobs(req.query.sm_id, function(results) {
        res.send(results[0]);
    });
});


router.get('/alljobs', function(req, res) {
    getAllJobs(req.query.sm_id, function (results) {
        res.send(results[0]);
    });
});

router.get('/browsecontractors', function(req, res) {
    res.render('browsecontractors');

});

router.get('/getInitialContractorList', function(req, res) {
    getClauseForContractorDetails(req.query.service, req.query.city, function(clause) {
        getContractorCount(clause, req.query.city, function(countcity){
            var city = countcity.city === '' ? 'All Cities' : countcity.city;
            getContractorList(clause, 1, 5, function(results) {
                var message = countcity.count === 0 ? "No Records present for City "+city : "Displaying Records for "+city;
                res.send({results: results, count: countcity.count, message: message});
            });
        });
    });
});

router.get('/getBookingContractorList', function(req, res) {
    getClauseForContractorDetails(req.query.service, req.query.city, function(clause) {
        getContractorCount(clause, req.query.city, req.query.service, function(countcity){
            var city = countcity.city === '' ? 'All Cities' : countcity.city;
            var service = getServiceId(req.query.service, function(service) {
                getContractorListForBooking(clause,service.service_id, 1, 5, function(results) {
                    res.send({results: results});
                });
            });
        });
    });
});

router.get('/getContractorListBookSLot', function(req, res) {
    console.log(req.query);
    getContractorAndWorkerList(req.query, function(results) {
        res.send(results);
    })
});

router.post('/bookSlot', function(req, res) {
    bookSlot(req.body, function(success) {
        res.send({success: success});
    });
});

router.post('/deleteSerRecord', function(req, res) {
    cancelUpcomingJob(req.body.record_id, function(success) {
        res.send({success: success});
    })
});

function cancelUpcomingJob(record_id, cb) {
    var slot_id;
    var worker_id;
    var sm_id;
    var connection = createConnection();
    connection.connect();
    connection.query("SELECT * FROM service_record WHERE record_id = ('"+record_id+"')", function(err, rows) {
        if (err) throw err;
        slot_id = rows[0].slot_id;
        worker_id = rows[0].worker_id;
        sm_id = rows[0].sm_id;
    });
    connection.beginTransaction(function(err) {
        if (err) throw err;
        connection.query("delete from service_record where record_id = '"+record_id+"'", function (err, rows) {
            if (err) {
                return connection.rollback(function () {
                    throw err;
                });
            }
            connection.query("delete from worker_availability where record_id = '"+record_id+"' " +
            "AND sm_id = '"+sm_id+"' AND slot_id = '"+slot_id+"'", function (err, result) {
                if (err) {
                    return connection.rollback(function() {
                        throw err;
                    });
                }
                connection.query("delete from schedule where slot_id = '"+slot_id+"'", function (err, result) {
                    if (err) {
                        return connection.rollback(function() {
                            throw err;
                        });
                    }
                    connection.commit(function(err) {
                        if (err) {
                            return connection.rollback(function () {
                                throw err;
                            });
                        }
                        connection.end();
                        return cb(true);
                    });
                });
            });
        });
    });
}

function bookSlot(obj, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query("SELECT service_id FROM service WHERE name = ('"+obj.service+"')", function(err, rows) {
        if (err) throw err;
        obj.service = rows[0];
    });
    var slot_id = Math.floor(Math.random() * 100000000) + 1;
    var record_id = Math.floor(Math.random() * 100000000) + 1;
    var slotObject = {};
    slotObject.slot_id = slot_id;
    slotObject.date = obj.date;
    slotObject.begin_time = obj.begin_time;
    slotObject.end_time = obj.end_time;
    var recordObject = {};
    recordObject.record_id = record_id;
    recordObject.worker_id = obj.worker_id;
    recordObject.sm_id = obj.sm_id;
    recordObject.slot_id = slot_id;
    recordObject.service_id = obj.service;
    recordObject.service_recipient = obj.service_recipient;
    recordObject.service_status = 'PENDING';
    recordObject.rating = NULL;
    recordObject.admin_review = false;
    var workerAvailObj = {};
    workerAvailObj.worker_id = obj.worker_id;
    workerAvailObj.sm_id = obj.sm_id;
    workerAvailObj.service_id = obj.service;
    workerAvailObj.slot_id = slot_id;
    connection.beginTransaction(function(err) {
        if (err) throw err;
        connection.query("INSERT INTO schedule SET ?", slotObject, function (err, rows) {
            if (err) {
                return connection.rollback(function () {
                    throw err;
                });
            }
            connection.query('INSERT INTO service_record VALUES ?', recordObject, function (err, result) {
                if (err) {
                    return connection.rollback(function() {
                        throw err;
                    });
                }
                connection.query('INSERT INTO worker_availability VALUES ?', workerAvailObj, function (err, result) {
                    if (err) {
                        return connection.rollback(function() {
                            throw err;
                        });
                    }
                    connection.commit(function(err) {
                        if (err) {
                            return connection.rollback(function () {
                                throw err;
                            });
                        }
                        connection.end();
                        return cb(true);
                    });
                });
            });
        });
    });
}

function getContractorAndWorkerList(obj, cb) {
    var begin_time, end_time;
    if (obj.time === "8:00 AM to 12 Noon") {
        begin_time = 800;
        end_time = 1159;
    } else if (obj.time === "12 Noon to 4 PM") {
        begin_time = 1200;
        end_time = 1559;
    } else {
        begin_time = 1600;
        end_time = 1959;
    }
    var connection = createConnection();
    var query = "select * from small_business where city = '"+obj.city+"'";
    connection.query(query, function(err, contractors) {
        if (err) throw err;
        for (i = 0; i < contractors.length; i++) {
            contractors[i].service = obj.service;
            contractors[i].begin_time = begin_time;
            contractors[i].end_time = end_time;
            contractors[i].date = obj.date;
        }
        async.map(contractors, getWorkers, function(err, modContractors) {
            if (err) throw err;
            console.log(modContractors);
            return cb(modContractors);
        });
    });
}

function getWorkers(contractor, cb) {
    var connection = createConnection();
    connection.connect();
    var query = "select * from worker where worker_id in (select worker_id from service_provider " +
        "where sm_id = '"+contractor.sm_id+"' AND service_id = (select service_id from service " +
        "where name = '"+contractor.service+"')) AND NOT EXISTS (select * from worker_availability " +
        "where sm_id = '"+contractor.sm_id+"' AND slot_id in (select slot_id from schedule where " +
        "date = STR_TO_DATE('"+contractor.date+"', '%m/%d/%Y') AND begin_time = '"+contractor.begin_time+"' AND " +
        "end_time = '"+contractor.end_time+"') AND worker_id = worker.worker_id)";
    connection.query(query, function(err, result) {
        if (err) throw err;
        connection.end();
        contractor.workers = result;
        return cb(null, contractor);
    });
}

function checkBusinessExists(email, cb) {
    var exists = null;
    var connection = createConnection({multipleStatements: true});
    connection.connect();
    connection.query('SELECT * FROM small_business_review WHERE email = "'+email+'"', function(err, rows, fields) {
        if (err) throw err;
        exists = rows.length === 0 ? false : true;
        connection.end();
        return cb(exists);
    });
}

function checkBusinessLogin(sm_id, password, cb) {
    var success = null;
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * FROM small_business WHERE sm_id = "'+sm_id+'" AND password = "'+password+'"', function(err, rows, fields) {
        if (err) throw err;
        if (rows.length === 1) {
            success  = rows[0];
            return cb(success)
        }
        return cb(success);
    });
}

function businesssignup(businessobject, cb) {
    businessobject.sm_id = Math.floor(Math.random() * 100000000) + 1;
    var connection = createConnection();
    connection.connect();
    connection.query('INSERT INTO small_business_review SET ?', businessobject, function(err, result) {
        if (err) {
            throw err;
        }
        connection.end();
        return cb(businessobject.sm_id);
    });
}

function getPendingJobs(sm_id, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('CALL GetJobs (' + sm_id + ')', function (err, result) {
        if (err) throw err;
        connection.end();
        return cb(result);
    });
}

function getAllJobs(sm_id, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('CALL GetAllJobs (' + sm_id + ')', function (err, result) {
        if (err) throw err;
        connection.end();
        return cb(result);
    });
}

function getContractorCount(clause, city, service,  cb) {
    var connection = createConnection();
    connection.connect();
    var query = 'Select count(*) as count from small_business'+clause;
    connection.query(query, function(err, count) {
        if (err) throw err;
        connection.end();
        var obj = {count: count[0].count, city: city}
        return cb(obj);
    });
}

function getContractorList(clause, rownumvar, numberrows, cb) {
    var rowoffset = (rownumvar - 1);
    var rownumclause = " LIMIT "+rowoffset+","+numberrows;
    var query = "SELECT sm_id, name, email, mobile, street_address, city, state, zip FROM small_business"+clause+rownumclause;
    var connection = createConnection();
    connection.connect();
    connection.query(query, function(err, contractors) {
        if (err) throw err;
        async.map(contractors, getServices, function(err, modContractors) {
            if (err) throw err;
            return cb(modContractors);
        });
    });

}

function getContractorListForBooking(clause, service, rownumvar, numberrows, cb) {
    var rowoffset = (rownumvar - 1);
    var rownumclause = " LIMIT "+rowoffset+","+numberrows;
    var query = "Select sm_id, name FROM small_business"+clause+rownumclause;
    var connection = createConnection();
    connection.connect();
    connection.query(query, function(err, contractors) {
        if (err) throw err;
        for (i = 0; i < contractors.length; i++) {
            contractors[i].service = service;
        }
        async.map(contractors, getBookedSlots, function(err, modContractors) {
            if (err) throw err;
            return cb(modContractors);
        });
    });

}

function getBookedSlots(contractor, cb) {
    var connection = createConnection();
    connection.connect();
    var tomorrow = 1;
    var nextweekdate = 7;
    var query = "select * from schedule where slot_id in (select slot_id from worker_availability where sm_id = '"+contractor.sm_id+"'" +
        " AND worker_id in (select worker_id from service_provider where sm_id = '"+contractor.sm_id+"' AND service_id = '"+contractor.service+"') " +
        "having count(worker_id) = (select count(worker_id) from service_provider where sm_id = '"+contractor.sm_id+"' " +
        "AND service_id = '"+contractor.service+"')) AND slot_id in (select slot_id from schedule where date between NOW()+1 AND NOW()+7)";
    connection.query(query, function(err, dates) {
        if (err) throw err;
        contractor.dates = dates;
        return cb(null, contractor);
    });


}

function getServices(contractor, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('select name from service where service_id in (select distinct service_id ' +
    'from service_provider where sm_id = "'+contractor.sm_id+'")', function(err, services) {
        if (err) throw err;
        contractor.services = services;
        delete contractor.sm_id;
        return cb(null, contractor);
    });
}

function getClauseForContractorDetails(service, city, cb) {
    var clause = city === "" ? "" : " WHERE city = '"+city+"'";
    if (service !== "") {
        var connection = createConnection();
        connection.connect();
        connection.query('select distinct sm_id from service_provider where service_id = ' +
        '(select service_id from service where name = "' + service + '")', function (err, result) {
            if (err) throw err;
            if (result.length > 0) {
                clause += clause === "" ? " WHERE " : " AND ";
                clause += "sm_id IN (";
                for (i = 0; i < result.length; i++) {
                    clause += "'" + result[i].sm_id + "'";
                    if (i < result.length - 1) {
                        clause += ", ";
                    }
                }
                clause += ")";
            }
            return cb(clause);
        });

    }
}

function getServiceId(service, cb) {
    var connection = createConnection();
    connection.connect();
    var query = "select service_id from service where name = '"+service+"'";
    connection.query(query, function(err, result) {
        if (err) throw err;
        connection.end();
        return cb(result[0])
    })
}

module.exports = {
    router: router,
    cancelUpcomingJob:cancelUpcomingJob,
    bookSlot:bookSlot,
    getContractorAndWorkerList:getContractorAndWorkerList,
    getWorkers:getWorkers,
    checkBusinessExists:checkBusinessExists,
    checkBusinessLogin:checkBusinessLogin,
    businesssignup:businesssignup,
    getPendingJobs:getPendingJobs,
    getAllJobs:getAllJobs,
    getContractorCount:getContractorCount,
    getContractorList:getContractorList,
    getContractorListForBooking:getContractorListForBooking,
    getBookedSlots:getBookedSlots,
    getServices:getServices,
    getClauseForContractorDetails:getClauseForContractorDetails,
    getServiceId:getServiceId,
    createConnection:createConnection
};
