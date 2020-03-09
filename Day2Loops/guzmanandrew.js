/*
 * No se detectaron problemas de código
 */

const fileString = require('fs');

function vowelsAndConsonants(text) {
  const sArray = text.split('');
  sArray.forEach((char) => {
    if (/[aeiou]/.test(char) === true) {
      // console.log(char);
    }
  });
  sArray.forEach((char) => {
    if (/[^aeiou]/.test(char) === true) {
      // console.log(char);
    }
  });
}

fileString.readFile('DATA.lst', 'utf8', (falla, datos) => {
  if (falla) {
    throw falla;
  }
  const datafile = datos;
  vowelsAndConsonants(datafile);
});

/*
$ node guzmanandrew.js
salida:
a a i o o j v s c r p t l p s
*/

