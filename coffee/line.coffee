
{Char} = require './char'

exports.Line = class Line

  constructor: (opts) ->
    file = opts.file
    y = opts.y
    line = opts.line.trimRight()
    @line = line.split("").map (char, x) ->
      new Char {char, x, y, file}

  isEmpty: ->
    @line.length is 0

  hasChild: ->
    @line.length > 0

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
    head = @shift()
    if not head?
      throw new Error "[Cirru Parser] cant unindent"
    if not head.isBlank()
      throw new Error "[Cirru Parser] #{head} is not blank"
    @shift() if @line[0]?.isBlank()

  shift: ->
    @line.shift()