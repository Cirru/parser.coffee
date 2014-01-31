
parser = require './coffee/parser'
fs = require 'fs'

names = [
  'demo'
  'folding'
  'indent'
  'line'
  'parentheses'
  'quote'
  'unfolding'
]

names.map (file) ->
  codename = "cirru/#{file}.cirru"
  jsonname = "cirru/#{file}.json"
  code = fs.readFileSync codename, 'utf8'
  json = fs.readFileSync(jsonname, 'utf8').trim()

  string = JSON.stringify (parser.parseShort code), null, 2
  if string is json
    console.log "Task >> #{file} << is ok"
  else
    console.log string, json
    console.log "Somthing wrong with >> #{file} <<"