
log = console.log
fs = require 'fs'

{parse} = require './parser'

draw = (json) -> JSON.stringify json, null, 2

file = fs.readFileSync '../example/code.cr', 'utf8'

log 'result:', (draw (parse file).ast)