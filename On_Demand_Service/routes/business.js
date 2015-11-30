var express = require('express');
var router = express.Router();
var mysql = require('mysql');
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
        console.log(clause);
        getContractorCount(clause, req.query.city, function(countcity){
            var city = countcity.city === '' ? 'All Cities' : countcity.city;
            getContractorList(clause, 1, 5, function(results) {
                var message = countcity.count === 0 ? "No Records present for City "+city : "Displaying Records for "+city;
                res.send({results: results, count: countcity.count, message: message});
            });
        });
    });
});

function createConnection() {
    var connection = mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : 'newpwd',
        port     :  3306,
        database : 'project',
        useTransaction: {
            connectionLimit: 10
        }
    });
    return connection
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

function getContractorCount(clause, city, cb) {
    var connection = createConnection();
    connection.connect();
    var query = 'Select count(*) as count from small_business'+clause;
    console.log(query);
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
    console.log(query);
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

function getServices(contractor, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('select name from service where service_id in (select distinct service_id ' +
    'from service_provider where sm_id = "'+contractor.sm_id+'")', function(err, services) {
        if (err) throw err;
        console.log(services);
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
            console.log('clause');
            console.log(clause);
            return cb(clause);
        });

    }
}


module.exports = router;
