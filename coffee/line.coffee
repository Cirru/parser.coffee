
{Char} = require './char'

exports.Line = class
  constructor: (opts) ->
    file = opts.file
    y = opts.y
    line = opts.line.trimRight()
    @line = line.split("").map (char, x) ->
      new Char {char, x, y, file}

  isEmpty: ->
    @line.length is 0

  isIndented: ->
    @getIndent() > 0

  isHeading: ->
    @getIndent() is 0

  getIndent: ->
    step = 0
    for char in @line
      if char.isBlank()
        step += 0.5
      else break
    Math.ceil step

  unindent: ->
    @shift()
    @shift() if @line[0].isBlank()

  shift: ->
    @line.shift()