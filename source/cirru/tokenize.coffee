
{Token} = require './token'
{Expr} = require './expr'
{caution} = require './caution'

exports.tokenize = (line) ->
  inQuote = no
  inEscape = no

  cache =
    tokens: []
    _token: undefined
    isEmpty: ->
      @_token.length is 0
    hasChild: ->
      @_token.length > 0
    giveOut: ->
      if @_token?
        @tokens.push @_token
        @_token = undefined
    add: (char) ->
      if @_token?
        @_token.addChar char
      else
        @_token = new Token char
    markQuoted: ->
      @_token.isBare = no

  until line.isEmpty()
    char = line.shift()
    if inQuote
      if inEscape
        cache.add char
        inEscape = off
      else
        if char.isDoubleQuote()
          cache.markQuoted()
          cache.giveOut()
          inQuote = off
        else if char.isBackslash()
          inEscape = on
        else
          cache.add char
    else
      if char.isBlank()
        cache.giveOut()
      else if char.isLeftParen()
        cache.giveOut()
        cache.add char
        cache.giveOut()
      else if char.isRightParen()
        cache.giveOut()
        cache.add char
        cache.giveOut()
      else if char.isDoubleQuote()
        cache.giveOut()
        inQuote = on
      else
        cache.add char

  if inQuote or inEscape
    message = "not closed at: \n#{caution char}\n"
    throw new Error "[Cirru Parser]: #{message}"

  cache.giveOut()
  convertToExpr cache.tokens

convertToExpr = (list) ->
  buildExpr = ->
    collection = []

    while list.length > 0
      head = list.shift()
      if head.isLeftParen()
        piece = buildExpr()
        collection.push (new Expr piece)
      else if head.isRightParen()
        return collection
      else
        collection.push head

    return collection

  return buildExpr()