/*
 * No se detectaron problemas de código
 * $ npx eslint guzmanandrew.js
 */
const fs = require("fs");

fs.readFile("DATA.lst", "utf8", (err, data) => {
    if(err) throw err;
    const datafile = data;
    vowelsAndConsonants(datafile);
})

function vowelsAndConsonants(s){
    const sArray = s.split("");
    sArray.forEach((char) => { 
        if (/[aeiou]/.test(char) == true) {
            console.log(char)
        }
    })
    sArray.forEach((char) => {
        if (/[^aeiou]/.test(char) == true) {
            console.log(char)
        }
    })
}

/*
$ node guzmanandrew.js
salida:
a a i o o j v s c r p t l p s
*/
