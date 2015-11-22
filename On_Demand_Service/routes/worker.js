var express = require('express');
var router = express.Router();
var mysql = require('mysql');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/getRating', function(req, res, next) {
    getWorkerRating(req.query.worker_id, req.query.sm_id, function(results) {
        res.send(results);
    });
});

function getWorkerRating(worker_id, sm_id, cb) {
    console.log(worker_id, sm_id);
    var connection = createConnection();
    connection.connect();
    connection.query("SET @worker_rating = ''; CALL getRating('" + worker_id + "', '" + sm_id + "', @worker_rating);SELECT @worker_rating;", function (err, result) {
        if (err) throw err;
        connection.end();
        return cb(result[result.length - 1]);
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
