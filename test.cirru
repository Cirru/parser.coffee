
var
  fs $ require :fs
  parser $ require :./lib/parser

var names $ []
  , :demo
  , :folding
  , :indent
  , :line
  , :parentheses
  , :quote
  , :unfolding
  , :html
  , :spaces
  , :comma

var test $ \ (file)

  var filename $ + :cirru/ file :.cirru
  var content $ fs.readFileSync (+ :ast/ file :.json) :utf8
  var wanting $ content.trim

  var ast $ parser.pare (fs.readFileSync filename :utf8) filename
  = ast $ JSON.stringify ast null 2

  if (is ast wanting)
    do
      console.log ":ok! fine with:" file
    do
      console.log ":failed! with file:" file
      console.log ast
  return

names.forEach test
