/**
 * Created by Varsha on 11/25/2015.
 */

var express = require('express');
var router = express.Router();
var mysql = require('mysql');

router.get('/signin', function(req,res){
    var c = req.cookies.loggedInAdminID;
    if (c===undefined)  {
        res.render('Admin_Signin');
    }
    else    {
        getSmallBusinesses(function(rows){
            res.cookie('loggedInAdminID', req.body.admin_id);
            res.render('Admin_Dashboard',{businesses: rows});
        });
    }
});

router.get('/activate_business/:id', function(req, res){
    console.log(req.params.id);
    var smID = req.params.id;
    var connection = create_Connection();
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
    var connection = create_Connection();
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

router.post('/signin', function(req, res){
    validate_Admin(req.body.admin_id, req.body.password, function(response){
        console.log(req.body);
        console.log(req.body.admin_id);
        console.log(req.body.password);

        if (response === null){
            res.render('Admin_Signin',{message:'Incorrect credentials'});
        }
        else    {
            getSmallBusinesses(function(rows){
                res.cookie('loggedInAdminID', req.body.admin_id);
                res.render('Admin_Dashboard',{name:response.first_name, id: response.admin_id, businesses: rows});
            });
        }
    })
});

function create_Connection() {
    var connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'password',
        database: 'project'
    });
    return connection
}

function validate_Admin(admin_Id, password, flag){
    var success = null;
    var connection = create_Connection();
    connection.connect();
    connection.query('SELECT * from admin WHERE admin_id="'+admin_Id+'" AND password ="'+password+'"', function(err, rows){
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
    var connection = create_Connection();
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


module.exports = router;
