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
