var express = require('express');
var router = express.Router();
var mysql = require('mysql');

/* GET home page. */
router.get('/browseservices', function(req, res, next) {
    getAllServices(function(services) {
        res.render('services', {services: services});
    });
});

function getAllServices(cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * FROM service_public', function(err, rows) {
        if (err) throw err;
        connection.end();
        return cb(rows);
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
