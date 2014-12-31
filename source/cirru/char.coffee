
exports.Char = class Char

  constructor: (opts) ->
    @_text = opts.char
    @x = opts.x
    @y =  opts.y
    @file = opts.file

  isBlank: ->
    @_text is " "

  isLeftParen: ->
    @_text is "("

  isRightParen: ->
    @_text is ")"

  isDollar: ->
    @_text is "$"

  isDoubleQuote: ->
    @_text is '"'

  isBackslash: ->
    @_text is "\\"

  isComma: ->
    @_text is ','

  getText: ->
    @_text