
{parse} = require '../coffee/parse'
{render} = require 'prettyjson'
stringify = (data) -> JSON.stringify data, null, 2

demo_file = './code.cr'

console.log render parse(demo_file).ast