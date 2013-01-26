
log = console.log
fs = require 'fs'

{parse} = require './parser'

draw = (json) -> JSON.stringify json, null, 2

test_file = '../example/code.cr'

do display = ->
  file = fs.readFileSync test_file, 'utf8'
  log 'result:', (draw (parse file).tree)
  log 'all:', (parse file).tree

fs.watchFile test_file, interval: 100, display