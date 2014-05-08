
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

  for expr in collection
    expr.resolveDollar()
    expr.resolveComma()

  collection

short = (node) ->
  if node.isExpr then node.map short
  else node.getText()

stand = (node) ->
  if node.isExpr then node.map stand
  else node.getStand()

exports.parse = (code, filename) ->
  (parse code, filename).map stand

exports.pare = (code, filename) ->
  (parse code, filename).map short
