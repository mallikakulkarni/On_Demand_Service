var mysql = require('mysql');
console.log("env="+global.env)

function createConnection() {
    var connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'newpwd',
        database: (global.env == 'test') ? 'tmp_test' : 'project',
    });
    return connection
}

module.exports = {
    createConnection: createConnection
};
