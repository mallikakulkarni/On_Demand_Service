/**
 * Created by Varsha on 11/25/2015.
 */

var express = require('express');
var router = express.Router();
var mysql = require('mysql');

router.get('/signin', function(req,res){
    var c = req.cookies.loggedInAdminID;
    if (c===undefined)  {
        res.render('adminSignin');
    }
    else    {
        getSmallBusinesses(function(rows){
            res.cookie('loggedInAdminID', req.body.adminID);
            getServices(function(services){
                res.render('adminDashboard',{services:services, businesses: rows});
            });
        });
    }
});

router.get('/activate_business/:id', function(req, res){
    console.log(req.params.id);
    var smID = req.params.id;
    var connection = createConnection();
    connection.query('CALL ActivateBusiness (' + smID + ')', function (err, result) {
        if(err) {
            console.log(err);
            res.send({done:false});
        }
        else    {
            console.log(result);
            res.send({done:true});
        }
    connection.end();
    });
});


router.get('/deactivate_business/:id', function(req, res){
    console.log(req.params.id);
    var connection = createConnection();
    var smID = req.params.id;
    connection.query('CALL DeactivateBusiness (' + smID + ')', function (err, response) {
        if(err) {
            console.log(err);
            res.send({done:false});
        }
        else    {
            console.log(response);
            res.send({done:true});
        }
    connection.end();
    });

});

router.get('/delete_service/:id', function(req, res){
    var connection = createConnection();
    var serviceID = req.params.id;
    connection.query(' CALL DeleteService ('+serviceID+')', function(err, response){
        if(err){
            console.log(err);
            res.send({done:false});
        }
        else{
            res.send({done:true});
        }
    });
});

router.get('/add_service/:service_name', function(req, res){
    var connection = createConnection();
    var service_name = req.params.service_name;
    var service_id = Math.floor(Math.random() * 100000) + 1;
    console.log(service_name);
    connection.query(' INSERT into service VALUES("'+service_id+'", "'+service_name+'")', function(err, response){

        if(err){
            console.log(err);
            res.send({done:false});
        }
        else{
            res.send({done:true});
        }
    });
});

router.post('/signin', function(req, res){
    validate_Admin(req.body.adminID, req.body.password, function(response){
        console.log(req.body);
        console.log(req.body.adminID);
        console.log(req.body.password);

        if (response === null){
            res.render('adminSignin',{message:'Incorrect credentials'});
        }
        else    {
            getSmallBusinesses(function(rows){
                res.cookie('loggedInAdminID', req.body.adminID);
                getServices(function(services){
                    res.render('adminDashboard',{services:services, businesses: rows});
                });
            });
        }
    })
});

function createConnection() {
    var connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'password',
        database: 'project'
    });
    return connection
}

function validate_Admin(adminID, password, flag){
    var success = null;
    var connection = createConnection();
    connection.connect();
    connection.query('SELECT * from admin WHERE admin_id="'+adminID+'" AND password ="'+password+'"', function(err, rows){
        if(err) throw err;
        if(rows.length === 1) {
            success = rows[0];
            return flag(success)
        }
        return flag(success)
    });
    connection.end();
}

function getSmallBusinesses(callback)   {
    var connection = createConnection();
    connection.connect();
    connection.query('select * from small_business', function(err, rows){
       if(err)  {
           throw err;
       }
        else    {
           callback(rows);
       }
    });
    connection.end();
}

function getServices(callback)   {
    var connection = createConnection();
    connection.connect();
    connection.query('select * from service', function(err, rows){
        if(err)  {
            console.log(err);
            throw err;
        }
        else    {
            callback(rows);
        }
    });
    connection.end();
}


module.exports = {
    router: router,
    getServices: getServices
};
