
bash = require "calabash"

bash.do "task",
  "pkill -f doodle"
  "coffee -wcm parser.coffee"
  "coffee -wcm html/test.coffee"
  "doodle parser.js html/test.js delay:0 cirru/"