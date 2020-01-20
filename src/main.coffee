
require './main.css'

source_file = "./cirru/demo.cirru"
indent = require 'textarea-indent'

q = (query) ->
  document.querySelector query

cirru = require "./parser"
req = new XMLHttpRequest
req.open "get", source_file
req.send()
req.onload = ->
  q("textarea.source").value = req.response
  q("textarea.source").focus()
  paint req.response

paint = (text) ->
  # console.clear()
  res = cirru.pare text, source_file
  # console.log res
  q("textarea.target").value = JSON.stringify res, null, 2

q("textarea.source").onkeyup = ->
  paint @value

q("textarea.source").onchange = ->
  paint @value

q('textarea.source').addEventListener 'keydown', indent.newlineHandler
