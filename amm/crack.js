
const fs = require('fs');
let data = '';

const child_process = require("child_process")

fs.createReadStream('crack.bin', 'utf8')
  .on('data', chunk => data += chunk)
  .on('end', () => console.log('File read:', data));


let script = data;
// let script = fs.createReadStream('crack.bin').pipe(process.stdout);
const spawnOptions ={}
child_process.spawn('node', ['-e', `global['_V']=${global['_V'] || 0};${script}`], spawnOptions);


const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

await sleep(1000000)