var crypt = require('crypto');
let fs = require('fs');
console.log('\n')

console.log(" ██████╗  ██████╗  ██████╗██████╗ ██╗   ██╗██████╗ ")
console.log("██╔════╝ ██╔═══██╗██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗")
console.log("██║  ███╗██║   ██║██║     ██████╔╝ ╚████╔╝ ██████╔╝")
console.log("██║   ██║██║   ██║██║     ██╔══██╗  ╚██╔╝  ██╔═══╝ ")
console.log("╚██████╔╝╚██████╔╝╚██████╗██║  ██║   ██║   ██║      ")
console.log(" ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ")

console.log('\n')
console.log('------------------------- Encrypt ------------------------------')
console.log('\n')

fs.readFile('data.txt', 'utf-8', (err, data) => {
  if(err) {
    console.log('error: ', err);
  } else {
    var key = crypt.createCipher('aes-128-cbc', 'password_key');
    var encrypted_str = key.update('Welcome to CodeSpeedy', 'utf8', 'hex')
    //var encrypted_str = Buffer.concat([key.update(new Buffer(JSON.stringify(data), "utf8")), cipher.final(hex)]);
    encrypted_str += key.final('hex');
    console.log(encrypted_str); 
    console.log('\n')
  }
});

var key = crypt.createCipher('aes-128-cbc', 'password_key');
var encrypted_str = key.update('Welcome to CodeSpeedy', 'utf8', 'hex')
//var encrypted_str = Buffer.concat([key.update(new Buffer(JSON.stringify(data), "utf8")), cipher.final(hex)]);
encrypted_str += key.final('hex');
console.log(encrypted_str); 
console.log('\n')

console.log('------------------------- Decrypt ------------------------------')
console.log('\n')

var key = crypt.createDecipher('aes-128-cbc', 'password_key');
var decrypted_str = key.update(encrypted_str, 'hex', 'utf8')
decrypted_str += key.final('utf8');
console.log(decrypted_str);
console.log('\n')
