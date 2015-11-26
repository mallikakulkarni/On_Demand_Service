/**
 * Created by Varsha on 11/25/2015.
 */

var express = require('express');
var router = express.Router();
var mysql = require('mysql');

router.get('/signin', function(req,res){
    res.render('Admin_Signin');
});

router.get('/activate_business', function(req, res){
    console.log(req);
    res
});

router.post('/signin', function(req, res){
    validate_Admin(req.body.adminid, req.body.password, function(response){
        console.log(req.body.adminid);
        console.log(req.body.password);

        if (response === null){
        res.render('Admin_Signin',{message:'Incorrect credentials'}); } else{
            res.render('Admin_Dashboard',{name:response.first_name, id: response.admin_id});
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

}

function Activate_Small_Business(){
    var connection = create_Connection();
    connection.connect();

}

module.exports = router;
