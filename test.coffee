
log = console.log
fs = require 'fs'

test_file = './example/code.cr'
draw = (json) -> JSON.stringify json, null, 2
{parse, wrap} = require './src/index'

task_convert = ->


  do display = ->
    file = fs.readFileSync test_file, 'utf8'
    tree = parse file
    log (draw tree)

  fs.watchFile test_file, interval: 100, display

task_wrap = ->

  do display = ->
    log "......."
    file = fs.readFileSync test_file, "utf8"
    log (wrap file)

  fs.watchFile test_file, interval: 100, display

# do task_wrap
do task_convert