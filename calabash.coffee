
require("calabash").do "task",
  "pkill -f doodle"
  'coffee -o src/ -wbc coffee/'
  'watchify -o build/build.js src/live.js -v'
  "doodle build/ index.html cirru/ log:yes"