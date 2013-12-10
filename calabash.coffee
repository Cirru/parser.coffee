
require("calabash").do "task",
  "pkill -f doodle"
  "coffee -o src/ -wcm coffee/"
  "doodle src/ index.html cirru/"