
{parse, error} = require '../coffee/parse'
{render} = require 'prettyjson'
path = require 'path'
fs = require 'fs'
stringify = (data) -> JSON.stringify data, null, 2

code_file = './test/piece.cr'
code_path = path.join __dirname, code_file

test = ->
  # console.log code_path
  ast = parse(code_file)
  # console.log ast
  if ast.errors.length > 0
    console.log ast.errors.join('\n')
  else
    # console.log render ast.tree

fs.watchFile code_path, interval: 200, test
test()

# console.log error x: 1, y: 0, text: 'error name', file: {path:'', text: '3xx'}