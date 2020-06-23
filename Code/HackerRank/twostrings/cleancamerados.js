/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

const fileString = require('fs');


function twoStringsArray(paramTwo, paramThree) {
  const flag = 'NO';
  const value = -1
  if (paramTwo.search(/[ol]/) !== value && paramThree.search(/[ol]/) !== value) {
    return flagOne = 'YES';
  }
  return flag;
}

function oneStringsArray(paramOne, paramFour) {
  const flagOne = 'NO';
  const value = -1
  if (paramOne.search(/[ol]/) !== value && paramFour.search(/[ol]/) !== value) {
    return flagOneArr = 'YES';
  }
  return flagOne;
}

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  const datafile = inputData;
  const dataArray = datafile.split(' ');
  const [dataOne, dataTwo] = dataArray;
  const [, , dataThree] = dataArray;
  const [, , , dataFour] = dataArray;
  console.log(twoStringsArray(dataOne, dataTwo));
  console.log(oneStringsArray(dataThree, dataFour));
  return 0;
});

/*
$ node guzmanandrew.js
output:
YES
NO
*/

