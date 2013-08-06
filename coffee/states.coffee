
proto =
  new: (object) ->
    child = {}
    child.__proto__ = @
    child[key] = value for key, value of object
    child.init?()
    child

exports.protos =
  caret: proto.new
    init: ->
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

  buffer: proto.new
    init: ->
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

  stack: proto.new
    init: ->
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

  indent: proto.new
    init: ->
      @level = 0
      @buffer = 0
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

  ast: proto.new
    init: ->
      @tree = []
      @entry = [@tree]
    push: (data) ->
      @entry[@entry.length - 1].push data
    nest: ->
      new_entry = []
      @entry[@entry.length - 1].push new_entry
      @entry.push new_entry
    ease: ->
      @entry.pop()
    newline: ->
      if @tree.length > 1 # prevent the first empty array
        @ease()
        @nest()

  folding: proto.new
    init: ->
      @stack = []
      @exists = no
      @level = 0
    add: (object) ->
      @stack.push object
      @level = object.level
      @exists = yes
    pop: ->
      object = @stack.pop()
      @exists = (@stack.length > 0)
      if @stack[0]?
        @level = @stack[@stack.length - 1].level
      object