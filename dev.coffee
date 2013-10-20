
bash = require "calabash"

bash.do "task",
  "pkill -f doodle"
  "coffee -o src/ -wcm coffee/"
  "doodle src/ index.html delay:0 cirru/"