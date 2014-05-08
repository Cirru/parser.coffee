
{Line} = require './line'

{parseBlock} = require './tree'

exports.caution = require('./caution').caution

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

stand = (node) ->
  if node.isExp then node.map stand
  else node.getStand()

exports.parse = (code, filename) ->
  (parse code, filename).map stand

exports.pare = (code, filename) ->
  (parse code, filename).map short
