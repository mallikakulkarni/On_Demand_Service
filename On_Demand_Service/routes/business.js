var express = require('express');
var router = express.Router();
var mysql = require('mysql');



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


module.exports = router;
