
{Line} = require './line'

{parseBlock} = require './tree'

exports.inspect = require('./inspect').inspect

parse = (text, path) ->
  text = text.trimRight()
  file = {text, path}

  lines = text
  .split("\n").map (line, y) ->
    new Line {line, y, file}
  .filter (line) ->
    line.hasChild()
  collection = parseBlock lines

  for exp in collection
    exp.resolveDollar()
    exp.resolveComma()

  collection

short = (node) ->
  if node.isExp then node.map short
  else node.getText()

exports.parse = parse

exports.pare = (code) ->
  result = (parse code)
  result.map short
