var express = require('express');
var router = express.Router();
var db = require('./db');
var createConnection = db.createConnection;

/* GET home page. */
    router.get('/', function(req, res, next) {
    res.render('index', { title: 'Express' });
});

router.get('/getRating', function(req, res, next) {
    getWorkerRating(req.query.worker_id, req.query.sm_id, function(results) {
        res.send(results);
    });
});

router.post('/signup', function(req, res, next) {
    console.log(req.body);
    if (typeof(req.body.confirm) === 'undefined') {
        console.log('Check');
        checkWorkerExists(req.body.workerObj.name, req.body.sm_id, function(exists) {
            if (exists) {
                console.log('exists');
                console.log(exists);
                res.send(true);
            } else {
                addWorker(req.body.workerObj, req.body.servicesObj, req.body.sm_id, function(success) {
                    res.send({exists: false, success: success});
                });
            }
        });
    } else {
        console.log('SkippedCheck');
        addWorker(req.body.workerObj, req.body.servicesObj, req.body.sm_id, function (success) {
            res.send({exists: false, success: success});
        })
    }
});

function checkWorkerExists(name, sm_id, cb) {
    console.log(name, sm_id);
    var connection = createConnection();
    connection.connect();
    connection.query("SELECT * FROM worker WHERE name = '"+name+"' AND sm_id = "+sm_id, function(err, rows) {
        if (err) throw err;
        connection.end();
        console.log(rows);
        if (rows.length > 0) {
            return cb(true);
        } else {
            return cb(false);
        }
    });
}

function addWorker(workerObj, servicesObj, sm_id, cb) {
    workerObj.worker_id = Math.floor(Math.random() * 100000000) + 1;
    sm_id = parseInt(sm_id);
    var servicesIdObj = [];
    var serviceString = '';
    for (i = 0; i < servicesObj.length; i++) {
        serviceString += '"'+servicesObj[i]+'", ';
    }
    serviceString = serviceString.substring(0, serviceString.length-2);
    console.log(serviceString);
    var services = [];
    workerObj.sm_id = sm_id;
    var connection = createConnection();
    connection.connect();
    connection.query("SELECT service_id FROM service WHERE name in ("+serviceString+")", function(err, rows) {
        if (err) throw err;
        for (i = 0; i < rows.length; i++) {
            var service = [workerObj.worker_id, sm_id, rows[i].service_id];
            services.push(service);
        }
        console.log(services);
    });
    connection.beginTransaction(function(err) {
        if (err) throw err;
        connection.query("INSERT INTO worker SET ?", workerObj, function (err, rows) {
            if (err) {
                return connection.rollback(function () {
                    throw err;
                });
            }
            connection.query('INSERT INTO service_provider VALUES ?', [services], function (err, result) {
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
}

function getWorkerRating(worker_id, sm_id, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query("SET @worker_rating = ''; CALL getRating('" + worker_id + "', '" + sm_id + "', @worker_rating);SELECT @worker_rating;", function (err, result) {
        if (err) throw err;
        connection.end();
        return cb(result[result.length - 1]);
    });
}

module.exports = {router: router, checkWorkerExists: checkWorkerExists};
