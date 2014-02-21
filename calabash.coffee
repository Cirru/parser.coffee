
require("calabash").do "task",
  "pkill -f doodle"
  'coffee -o src/ -wbc coffee/'
  'cjsify -o build/build.js --inline-source-map -w coffee/live.coffee'
  "doodle build/ index.html cirru/ log:yes"