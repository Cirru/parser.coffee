
{parse} = require '../coffee/parse'
{render} = require 'prettyjson'
path = require 'path'
fs = require 'fs'
stringify = (data) -> JSON.stringify data, null, 2

code_file = './code.cr'
code_path = path.join __dirname, code_file

test = ->
  # console.log code_path
  ast = parse(code_file).ast
  # console.log ast
  if ast.errors.length > 0
    console.log ast.errors.join('\n')
  else
    console.log render ast.tree

fs.watchFile code_path, interval: 200, test
test()