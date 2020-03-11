/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

const fileString = require('fs');

function vowelsAndConsonants(text) {
  const sArray = text.split('');
  sArray.forEach((char) => {
    if (/[aeiou]/.test(char) === true) {
      console.log(char);
    }
  });
  sArray.forEach((char) => {
    if (/[^aeiou]/.test(char) === true) {
      console.log(char);
    }
  });
}

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  if (fail) {
    throw fail;
  }
  const datafile = inputData;
  vowelsAndConsonants(datafile);
});

/*
$ node guzmanandrew.js
output:
a a i o o j v s c r p t l p s
*/

