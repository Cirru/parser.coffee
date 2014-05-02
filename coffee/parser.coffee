
{Line} = require './line'

{parseBlock} = require './tree'

parse = (text, path) ->
  text = text.trimRight()
  file = {text, path}
  lines = text.split("\n").map (line, y) ->
    new Line {line, y, file}
  collection = parseBlock lines
  for exp in collection
    exp.resolveDollar()
    exp.resolveComma()
  collection

short = (data) ->
  if Array.isArray data then data.map short
  else data.text

exports.parse = parse

exports.pare = (code) ->
  short (parse code)