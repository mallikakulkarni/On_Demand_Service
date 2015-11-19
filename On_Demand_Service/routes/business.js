var express = require('express');
var router = express.Router();
var mysql = require('mysql');



/* GET home page. */
router.post('/bsignup', function(req, res, next) {
    console.log(req.body);
    var businessExists = checkBusinessExists(req.body.email);

    console.log(businessExists);
    if (businessExists) {
        res.send('Your record Exists. Please Login');
    } else {
        businesssignup(req.body);
        res.render('businesshomepage');
    }
});

router.get('/bsignup', function(req, res) {
   res.send('Got it');
});


function createConnection() {
    var connection = mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : 'newpwd',
        port     :  3306,
        database : 'project',
        useTransaction: {
            connectionLimit: 5
        }
    });
    return connection
}

function checkBusinessExists(email, function() {
    var exists = null;
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * FROM small_business WHERE email = "'+email+'"', function(err, rows, fields) {
        console.log('Here2');
        if (err) throw err;
    });
});

function businesssignup(businessobject) {
    var test1 = {id: '8', name: 'H'};
    var test2 = {id: '3', name: 'C'};
    var connection = createConnection();
    connection.connect();
    connection.beginTransaction(function(err) {
        if (err) { throw err; }
        connection.query('INSERT INTO test SET ?', test1, function(err, result) {
            if (err) {
                connection.rollback(function() {
                    throw err;
                });
            }
            connection.query('INSERT INTO test2 SET ?', test2, function(err, result) {
                if (err) {
                    connection.rollback(function() {
                        throw err;
                    });
                }
                connection.commit(function(err) {
                    if (err) {
                        connection.rollback(function () {
                            throw err;
                        });
                    }
                    console.log('Transaction Complete.');
                });
            });
        });
    });
}

module.exports = router;
