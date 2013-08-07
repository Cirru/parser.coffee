
{parse} = require '../coffee/parse'
{render} = require 'prettyjson'
path = require 'path'
fs = require 'fs'
stringify = (data) -> JSON.stringify data, null, 2

code_file = './piece.cr'
code_path = path.join __dirname, code_file

# console.log code_path
ast = parse(code_file).ast
# console.log ast
if ast.error?
  console.log ast.error
else
  console.log render ast

fs.watchFile code_path, interval: 200, ->
  console.log render parse(code_file).ast