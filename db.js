const mysql = require('mysql2');

const user = "root";
const password = "amir2015";
const database = "wasserwerk";

const con = mysql.createConnection({
    host: "127.0.0.1",
    user: user,
    password: password,
    database: database
});

con.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err.stack);
        return;
    }
    console.log("Connected to database!");
});

module.exports = con;
