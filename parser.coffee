
class Charactar
  constructor: (opts) ->
    @char = opts.char
    # @x = opts.x
    # @y =  opts.y
    # @file = opts.file

  isEmpty: ->
    @char is " "

class Inline
  constructor: (opts) ->
    file = opts.file
    y = opts.y
    @line = opts.line.split("").map (char, x) ->
      new Charactar {char, x, y, file}

  isEmptyLine: ->
    if @line.length is 0
      yes
    else
      @line.every (char) ->
        char.isEmpty()

  getIndent: ->
    n = 0
    for char in @line
      if char.isEmpty()
        n += 1
      else
        break
    Math.ceil (n / 2)

  dedent: ->
    @line.shift()
    first = @line[0]
    if first.isEmpty()
      @line.shift()

wrap_text = (text, filename) ->
  file = {text, filename}
  text.split("\n").map (line, y) ->
    new Inline {line, y, file}

parseNested = (curr_lines) ->
  curr_lines.map (line) ->
    line.dedent()
  parseBlock curr_lines

parseBlock = (curr_lines) ->
  collection = []
  buffer = []
  digest_buffer = ->
    if buffer.length > 0
      line = buffer[0]
      if (collection.length is 0) and (line.getIndent() > 0)
        collection.push (parseNested buffer)
      else
        collection.push (parseTree buffer)
      buffer = []
  curr_lines.map (line) ->
    return if line.isEmptyLine()
    if line.getIndent() is 0
      digest_buffer()
    buffer.push line
  digest_buffer()
  collection

parseTree = (tree) ->
  follows = tree[1..].map (line) ->
    line.dedent()
    line
  func = tree[0]
  if follows.length > 0
    args = parseBlock follows
    {func, args}
  else
    {func}

parse = (text, filename) ->
  whole_list = wrap_text text, filename
  parseBlock whole_list

error = ->

# loader for RequireJS, CommonJS and browsers

if define?
  define
    parse: parse
    error: error
else if exports?
  exports.parse = parse
  exports.error = error
else if window?
  window.parse = parse
  window.error = error