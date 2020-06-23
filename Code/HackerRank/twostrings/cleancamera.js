/**
 * No code problems detected
 * npx eslint guzmanandrew.js
 */

/* eslint no-console: ["error", { allow: ["log"] }] */

const fileString = require('fs');


function twoStrings(paramOne, paramTwo) {
  
  var flag = 'NO';

  for (var i = 0; i < paramTwo.length; i = i + 1) {

    if (paramOne.search(paramTwo[i]) !== -1) {
      flag = 'YES';
      break;
    }

  }
  return flag;
}

fileString.readFile('DATA.lst', 'utf8', (fail, inputData) => {
  const datafile = inputData;
  const dataArray = datafile.split(' ');
  const [dataOne, dataTwo, dataThree, dataFour] = dataArray;
  
  const dataTwoArray = dataTwo;
  const dataThreeArray = dataThree;
  const dataFourArray = dataFour;
  console.log(twoStrings(dataOne, dataTwoArray));
  console.log(twoStrings(dataThreeArray, dataFourArray));
});

/*
$ node guzmanandrew.js
output:
YES
NO
*/
