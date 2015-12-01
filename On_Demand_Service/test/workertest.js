/**
 * Created by mallika on 11/30/15.
 */


var request = require('supertest')
    , express = require('express');

var app = express();

describe('GET /user', function(){
    it('respond with json', function(done){
        request(app)
            .get('/users')
            .set('Accept', 'application/json')
            .expect('Content-Type', "text/html; charset=utf-8")
            .expect(404, done);
    })
})

describe('POST /bsignup', function() {
    it('respond with with business signup', function(done) {
        request(app)
            .get('/business/bsignup')
            .set('Accept', 'application/json')
            .expect('Content-Type', "text/html; charset=utf-8")
            .expect(500, done);
    })
})