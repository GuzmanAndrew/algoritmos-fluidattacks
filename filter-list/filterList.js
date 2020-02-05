/**
 * No code problems detected
 * $ npx eslint filterList.js
 */
let array = [1,2,'a','b']

function filter_list(arr) {
    for (let i = 0; i < arr.length; i++) {
        if (typeof arr[i] === 'number') {
            console.log(arr[i])
        }
    }
}

filter_list(array)

/*
$ node filterList.js
output:
1 2
*/
