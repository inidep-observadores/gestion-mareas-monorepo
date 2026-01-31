const { exec } = require('child_process');
exec('npx jest src/mareas/mareas.service.spec.ts -t "should create first stage automatically"', { cwd: process.cwd() }, (error, stdout, stderr) => {
    console.log('--- STDOUT ---');
    console.log(stdout);
    console.log('--- STDERR ---');
    console.log(stderr);
});
