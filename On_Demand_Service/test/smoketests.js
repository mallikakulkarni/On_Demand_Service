var assert = require('assert');
var admin = require('../routes/admin')
var business = require('../routes/business')
var customer = require('../routes/customer')
var services = require('../routes/services')


describe('Admin', function () {
    describe('getServices', function () {
        it('has 2 getServices', function (done) {
            admin.getServices(function (rows) {
                assert.equal(rows.length, 2);
                done();
            })
        });
    });

    describe('getSmallBusinesses', function () {
        it('has 2 small businesses', function (done) {
            admin.getSmallBusinesses(function (rows) {
                assert.equal(rows.length, 2);
                done();
            })
        });
    });

    describe('validate_Admin', function () {
        it('admin validation works', function (done) {
            admin.validate_Admin('1', 'abc', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getServices', function () {
        it('has 2 getServices', function (done) {
            admin.getServices(function (rows) {
                assert.equal(rows.length, 2);
                done();
            })
        });
    });

});


describe('Business', function () {
    describe('getContractorAndWorkerList', function () {
        it('getContractorAndWorkerList works', function (done) {
            business.getContractorAndWorkerList('8:00 AM to 12 Noon', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });
    //
    //describe('getWorkers', function () {
    //    it('getWorkers works', function (done) {
    //        business.getContractorList('', 1, 1, function(contractors) {
    //            business.getWorkers(contractors[0], function (response) {
    //                assert.notEqual(response, null);
    //                done();
    //            });
    //        });
    //    });
    //});

    describe('getPendingJobs', function () {
        it('getPendingJobs works', function (done) {
            business.getPendingJobs('1', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getAllJobs', function () {
        it('getAllJobs works', function (done) {
            business.getAllJobs('1', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getContractorCount', function () {
        it('getContractorCount works', function (done) {
            business.getContractorCount('', '', '', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getContractorList', function () {
        it('getContractorList works', function (done) {
            business.getContractorList(' ', 1, 2, function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getContractorListForBooking', function () {
        it('getContractorListForBooking works', function (done) {
            business.getContractorListForBooking(' ', 'abc', 1, 2, function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getServices', function () {
        it('getServices works', function (done) {
            business.getServices({sm_id: 1}, function (err, response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getClauseForContractorDetails', function () {
        it('getClauseForContractorDetails works', function (done) {
            business.getClauseForContractorDetails('1', 'abc', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });

    describe('getServiceId', function () {
        it('getServiceId works', function (done) {
            business.getServiceId('Nanny Services', function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });
});

describe('Customer', function () {
    describe('getCustomerPublicView', function () {
        it('getCustomerPublicView works', function (done) {
            customer.getCustomerPublicView(1, function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });
});

describe('Services', function () {
    describe('getAllServices', function () {
        it('getAllServices works', function (done) {
            services.getAllServices(function (response) {
                assert.notEqual(response, null);
                done();
            })
        });
    });
});