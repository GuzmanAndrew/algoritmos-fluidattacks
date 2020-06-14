/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

const fileString = require('fs');

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  if (fail) {
    throw fail;
  }
  const datafile = inputData;
  const dataresult = datafile.split(" ")
  const dataUno = dataresult[0]
  const dataDos = dataresult[1]
  
  // Saber tipo de dato:
  //const sumOne = typeof(dataUno)

  // Casting de string a int
  dataNumOne = parseFloat(dataUno)

  // Casting de string a int
  dataNumTwo = parseFloat(dataDos)

  sumOne = dataNumOne + dataNumTwo

  restOne = dataNumOne - dataNumTwo

  mulOne = dataNumOne * dataNumTwo

  divOne = dataNumOne / dataNumTwo

  console.log(sumOne.toFixed(2))

  console.log(restOne.toFixed(2))

  console.log(mulOne.toFixed(2))

  console.log(divOne.toFixed(2))

});

/*
$ node guzmanandrew.js
output:
a a i o o j v s c r p t l p s
*/
