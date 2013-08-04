
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

exports.Caret = Caret
exports.Buffer = Buffer
exports.Stack = Stack