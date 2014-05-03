
{Char} = require './char'

exports.Line = class Line

  constructor: (opts) ->
    file = opts.file
    y = opts.y
    line = opts.line.trimRight()
    @_line = line.split("").map (char, x) ->
      new Char {char, x, y, file}

  isEmpty: ->
    @_line.length is 0

  hasChild: ->
    @_line.length > 0

  isIndented: ->
    @getIndent() > 0

  isHeading: ->
    @getIndent() is 0

  getIndent: ->
    step = 0
    for char in @_line
      if char.isBlank()
        step += 0.5
      else break
    Math.ceil step

  unindent: ->
    head = @shift()
    @shift() if @_line[0]?.isBlank()

  shift: ->
    @_line.shift()