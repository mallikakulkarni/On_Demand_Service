var express = require('express');
var router = express.Router();
var mysql = require('mysql');

/* GET home page. */
router.get('/getPublicData', function(req, res, next) {
    console.log(req.query.record_id);
    getCustomerPublicView(req.query.record_id, function(result) {
        res.send(result);
    });
});

router.post('/login', function(req, res) {
    validatelogin(req.body.email, req.body.password, function(result) {
        console.log(result);
        if (result.exists === false) {
            res.render('customersignup');
        } else {
            if (result.correctlogin === true) {
                res.render('customerhomepage', {name: result.name, email: result.email, city: result.city});
            } else {
                res.render('incorrectcustomerlogin');
            }
        }
    })
});

router.post('/rate', function(req, res) {
    console.log('Here');
    console.log(req.body);
    insertRating(req.body.record_id, req.body.val, function(message) {
        if (message === true) {
            res.send({message : "Rating inserted"})
        }
    });
});

router.get('/rateJobs', function(req, res) {
    rateJobs(req.query.email, function(result) {
        res.send(result);
    });
});


function insertRating (record_id, rating, cb) {
    var connection = createConnection();
    connection.connect();
    var query = 'update service_record set rating = '+rating+' where record_id = "'+record_id+'"';
    console.log(query);
    connection.query(query, function(err, result) {
        if (err) throw err;
        console.log(result);
        connection.end();
        return cb(true);
    });
}

function rateJobs(email, cb) {
    console.log(email);
    var connection = createConnection();
    connection.connect();
    var query = 'select * from service_record_public where status != "PENDING" AND rating IS NULL AND customer = "'+email+'"';
    connection.query(query, function(err, records) {
        if (err) throw err;
        connection.end();
        console.log('records');
        console.log(records);
        return cb(records);
    })
}


function validatelogin(email, password, cb) {
    console.log(email);
    console.log(password);
    var connection = createConnection();
    connection.connect();
    var query = 'select * from service_recipient where email = "'+email+'"';
    console.log(query);
    connection.query(query, function(err, result) {
        if (err) throw err;
        console.log(result);
        if (result.length === 0) {
            return cb({exists: false});
        } else {
            var correctlogin = password === result[0].password ? true : false;
            if (correctlogin === true) {
                return cb({exists: true, correctlogin: correctlogin, name: result[0].name, email: result[0].email, city: result[0].city});
            } else {
                return cb({exists: true, correctlogin: correctlogin});
            }
        }
    })
}


function getCustomerPublicView(record_id, cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * FROM CUSTOMER_PUBLIC WHERE email = ' +
                    '(SELECT service_recipient FROM service_record WHERE record_id = '+record_id+')', function(err, result){
        if (err) throw err;
        connection.end();
        return cb(result[0]);
    });

}

function createConnection() {
    var connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'newpwd',
        port: 3306,
        database: 'project',
        useTransaction: {
            connectionLimit: 5
        },
        multipleStatements: true
    });
    return connection
}

module.exports = router;
