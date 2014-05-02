
{Exp} = require './exp'
{tokenize} = require './tokenize'

exports.parseBlock = parseBlock = (lines) ->

  cache =
    collection: []
    _data: []
    isEmpty: ->
      @_data.length is 0
    giveOut: ->
      if @_data.length > 0
        @collection.push (buildExp @_data)
        @_data = []
    push: (line) ->
      @_data.push line

  for line in lines
    if line.isHeading() then cache.giveOut()
    cache.push line

  cache.giveOut()

  cache.collection

buildExp = (pieces) ->
  collection = []
  funcOne = pieces[0]
  if funcOne[0].isIndented()
    list = funcOne.map (line) ->
      line.unindent()
    collection.push (buildExp list)
  else
    head = tokenize funcOne
    collection.push head...

  for paraOne in pieces[1..]
    list = paraOne.map (line) ->
      line.unindent()
    collection.push (buildExp list)

  new Exp collection