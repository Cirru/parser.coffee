
{parse} = require '../coffee/parse'
{render} = require 'prettyjson'
path = require 'path'
fs = require 'fs'
stringify = (data) -> JSON.stringify data, null, 2

code_file = './code.cr'
code_path = path.join __dirname, code_file

console.log code_path
console.log stringify parse(code_file).ast

fs.watchFile code_path, interval: 200, ->
  console.log stringify parse(code_file).ast