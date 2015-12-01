console.log("env="+global.env)

function createConnection() {
    var connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: (global.env != 'test') ? 'newpwd' : 'tmp_test',
        database: 'project'
    });
    return connection
}

module.exports = {
    createConnection: createConnection
};
