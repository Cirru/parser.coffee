
{Expr} = require './expr'
{tokenize} = require './tokenize'

exports.parseBlock = parseBlock = (lines) ->

  cache =
    collection: []
    _data: []
    isEmpty: ->
      @_data.length is 0
    giveOut: ->
      if @_data.length > 0
        @collection.push (buildExpr @_data)
        @_data = []
    push: (line) ->
      @_data.push line

  for line in lines
    if line.isHeading() then cache.giveOut()
    cache.push line

  cache.giveOut()

  cache.collection

buildExpr = (pieces) ->
  funcOne = pieces[0]

  if funcOne.isIndented()
    line.unindent() for line in pieces
    return new Expr (parseBlock pieces)
  else
    head = tokenize funcOne
    linesAfter = pieces[1..]
    line.unindent() for line in linesAfter
    collection = parseBlock linesAfter
    list = head.concat collection
    return new Expr list
