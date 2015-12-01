var express = require('express');
var router = express.Router();
var db = require('./db');
var createConnection = db.createConnection;

/* GET home page. */
router.get('/browseservices', function (req, res, next) {
    getAllServices(function (services) {
        res.render('services', {services: services});
    });
});

function getAllServices(cb) {
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * FROM service_public', function (err, rows) {
        if (err) throw err;
        connection.end();
        return cb(rows);
    });
}

module.exports = {router: router, getAllServices: getAllServices};
