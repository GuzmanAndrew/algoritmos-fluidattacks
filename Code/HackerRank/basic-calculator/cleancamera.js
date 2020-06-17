/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

var fileString = require('fs');

var dataNumOne = 0
var dataNumTwo = 0
var sum = 0

function sumOne(param1, param2){
  sum = param1 + param2
  console.log(sum.toFixed(2))
}

function resOne(param1, param2){
  sum = param1 - param2
  console.log(sum.toFixed(2))
}

function mulOne(param1, param2){
  sum = param1 * param2
  console.log(sum.toFixed(2))
}

function divOne(param1, param2){
  sum = param1 / param2
  console.log(sum.toFixed(2))
}

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  if (fail) {
    throw fail;
  }

  var datafile = inputData;
  var dataresult = datafile.split(" ")
  var dataUno = dataresult[0]
  var dataDos = dataresult[1]
  
  // Saber tipo de dato:
  //const sumOne = typeof(dataUno)

  // Casting de string a int
  dataNumOne = parseFloat(dataUno)

  // Casting de string a int
  dataNumTwo = parseFloat(dataDos)

  sumOne(dataNumOne, dataNumTwo)

  resOne(dataNumOne, dataNumTwo)

  mulOne(dataNumOne, dataNumTwo)

  divOne(dataNumOne, dataNumTwo)

});

/*
$ node guzmanandrew.js
output:
6.30
-1.70
9.20
0.57
*/

//------------------ SEGUNDA DORMA CON BUENAS PRACTICAS -------------------

/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

const fileString = require('fs');

function sumOne(paramOne, paramTwo) {
  const sum = paramOne + paramTwo;
  console.log(sum.toFixed(2));
  return 0;
}

function resOne(paramOne, paramTwo) {
  const res = paramOne - paramTwo;
  console.log(res.toFixed(2));
  return 0;
}

function mulOne(paramOne, paramTwo) {
  const mul = paramOne * paramTwo;
  console.log(mul.toFixed(2));
  return 0;
}

function divOne(paramOne, paramTwo) {
  const div = paramOne / paramTwo;
  console.log(div.toFixed(2));
  return 0;
}

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  const datafile = inputData;
  const dataresult = datafile.split(' ');
  /**
  * Esto es una destruccion de array
  * En este link se explica mejor:
  * https://dev.to/sarah_chima/destructuring-assignment---arrays-16f#:~:text=Destructuring%20assignment%20is%20a%20cool,and%20assign%20them%20to%20variables.
  */
  const [ dataUno, dataDos ] = dataresult;
  const dataTres = dataDos;
  const dataNumOne = parseFloat(dataUno);
  const dataNumTwo = parseFloat(dataTres);

  sumOne(dataNumOne, dataNumTwo);

  resOne(dataNumOne, dataNumTwo);

  mulOne(dataNumOne, dataNumTwo);

  divOne(dataNumOne, dataNumTwo);

  return 0;
});

/*
$ node guzmanandrew.js
output:
6.30
-1.70
9.20
0.57
*/


