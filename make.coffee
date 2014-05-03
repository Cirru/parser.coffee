
project = 'repo/cirru/parser'
interval = interval: 300
watch = no

require 'shelljs/make'
fs = require 'fs'
station = require 'devtools-reloader-station'
browserify = require 'browserify'
exorcist = require 'exorcist'
{renderer} = require 'cirru-html'

startTime = (new Date).getTime()
process.on 'exit', ->
  now = (new Date).getTime()
  duration = (now - startTime) / 1000
  console.log "\nfinished in #{duration}s"

reload = -> station.reload project if watch

compileCoffee = (name, callback) ->
  exec "coffee -o js/ -bc coffee/#{name}", ->
    console.log "done: coffee, compiled coffee/#{name}"
    do callback

packJS = ->
  bundle = browserify ['./js/main']
  .bundle debug: yes
  bundle.pipe (exorcist 'build/build.js.map')
  .pipe (fs.createWriteStream 'build/build.js', 'utf8')
  bundle.on 'end', ->
    console.log 'done: browserify'
    do reload

target.folder = ->
  mkdir '-p', 'cirru', 'coffee', 'js', 'build', 'css'
  exec 'touch cirru/index.cirru css/style.css'
  exec 'touch coffee/main.coffee'
  exec 'touch README.md .gitignore .npmignore'

target.html = ->
  file = 'cirru/index.cirru'
  render = renderer (cat file), '@filename': file
  html = render()
  fs.writeFile 'index.html', html, 'utf8', (err) ->
    console.log 'done: cirru'
    do reload

target.js = ->
  exec 'coffee -o js/ -bc coffee/'

target.compile = ->
  target.html()
  exec 'coffee -o js/ -bc coffee/', ->
    packJS()

target.watch = ->
  watch = yes
  fs.watch 'cirru/', interval, ->
    target.html()
  fs.watch 'coffee/', interval, (type, name) ->
    if type is 'change'
      compileCoffee name, ->
        do packJS

  station.start()

names = [
  'demo'
  'folding'
  'indent'
  'line'
  'parentheses'
  'quote'
  'unfolding'
  'html'
  'spaces'
  'comma'
]

test = (file) ->
  parser = require './coffee/parser'

  code = cat "cirru/#{file}.cirru"
  wanting = (cat "ast/#{file}.json").trim()

  ast = JSON.stringify (parser.pare code), null, 2

  if ast is wanting
    console.log "ok! fine with: #{file}"
  else
    console.log "failed! with file: #{file}"
    console.log ast

target.test = ->
  test name for name in names

target.run = ->
  text 'demo'