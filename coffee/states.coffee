
class Caret
  constructor: ->
    @x = 0
    @y = 0
  forward: ->
    @x += 1
  newline: ->
    @y += 1
    @x = 0
  wrap: (object) ->
    object.x = @x
    object.y = @y
    object

class Buffer
  constructor: ->
    @text = null
  add: (char) ->
    if @text?
      @text += char
    else
      @text = char
  clear: ->
    @text = null
  out: ->
    text = @text
    @clear()
    text

class Stack
  constructor: ->
    @raw = []
    @now = 'empty'
  push: (item) ->
    @raw.push item
    @now = item.name
  pop: ->
    @raw.pop()
    if @raw.length > 0
      @now = @raw[@raw.length - 1].name
    else
      @now = 'empty'

class Indent
  constructor: ->
    @level = 0
    @buffer = 0
  indent: ->
    @level += 1
  dedent: ->
    @level -= 1
    if @level < 0
      throw new Error 'indentation is not <0'
  count: ->
    @buffer += 1
  skip: ->
    @buffer = 0
  read: ->
    diff = @buffer - @level
    [@level, @buffer] = [@buffer, 0]
    if Math.abs(diff % 2) is 1
      throw new Error 'odd indentation!'
    if diff > 0
      type: 'indent'
      step: diff / 2
    else if diff < 0
      type: 'dedent'
      step: - diff / 2
    else
      type: 'plain'


exports.Indent = Indent
exports.Caret = Caret
exports.Buffer = Buffer
exports.Stack = Stack