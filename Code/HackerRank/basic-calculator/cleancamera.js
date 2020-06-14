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
