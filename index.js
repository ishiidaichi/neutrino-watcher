const chokidar = require('chokidar');
const childProcess = require('child_process')

// One-liner for current directory
chokidar.watch('NEUTRINO/score/musicxml/*.musicxml').on('all', (event, path) => {

  let fileMatch = path.match(/([^\\/.]+)\.musicxml$/)
  let modelDir;
  let cmd;

  if (fileMatch.length > 1) {
    let fileName = fileMatch[1]
    console.log(event, path, fileName)

    if (event === 'change') {
      console.log('encoding start:', fileName)

      modelDir = process.argv[2]
      cmd = 'NEUTRINO\\Execute.bat '

      let spawnProcess = childProcess.spawn(cmd, [fileName, modelDir])
      spawnProcess.stdout.on("data", (data) => {
        console.log(`${data}`);
      })
      spawnProcess.stderr.on('data', (data) => {
        console.error(`${data}`);
      });
      spawnProcess.on("close", (code) => {
        console.log(`child process exited with code ${code}`);
      })
    }
  } else {
    console.log('.musicxml file not found: ', path)
  }
})