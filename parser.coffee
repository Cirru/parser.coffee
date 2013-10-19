
class Charactar
  constructor: (opts) ->
    @char = opts.char
    # @x = opts.x
    # @y =  opts.y
    # @file = opts.file

  isBlank: ->
    @char is " "

  isOpenParen: ->
    @char is "("

  isCloseParen: ->
    @char is ")"
  
  isDollar: ->
    @char is "$"

  isDoubleQuote: ->
    @char is '"'

  isBackslash: ->
    @char is "\\"

class Inline
  constructor: (opts) ->
    file = opts.file
    y = opts.y
    @line = opts.line.split("").map (char, x) ->
      new Charactar {char, x, y, file}

  isEmpty: ->
    if @line.length is 0
      yes
    else
      @line.every (char) ->
        char.isBlank()

  getIndent: ->
    n = 0
    for char in @line
      if char.isBlank()
        n += 1
      else
        break
    Math.ceil (n / 2)

  dedent: ->
    @line.shift()
    first = @line[0]
    if first.isBlank()
      @line.shift()

  shift: ->
    @line.shift()

  line_end: ->
    @line.length is 0

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
    return if line.isEmpty()
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
  console.log JSON.stringify (tokenize func), null, 2
  if follows.length > 0
    args = parseBlock follows
    {func, args}
  else
    {func}

window.tokenize = (line) ->
  tokens = []
  buffer = undefined
  quote_mode = no
  escape_mode = no

  digest_buffer = (as_string) ->
    type = if as_string? then "string" else "text"
    if buffer?
      tokens.push {type, buffer}
      buffer = undefined

  add_buffer = (the_char) ->
    if buffer?
      buffer.char += the_char.char
    else
      buffer = char

  until line.isEmpty()
    char = line.shift()
    if quote_mode
      console.log "in quote"
      if escape_mode
        add_buffer char
        escape_mode = off
      else
        if char.isDoubleQuote()
          digest_buffer "string"
          quote_mode = off
        else if char.isBackslash()
          escape_mode = on
        else
          add_buffer char
    else
      if char.isBlank()
        digest_buffer()
      else if char.isOpenParen()
        digest_buffer()
        tokens.push type: "openParen"
      else if char.isCloseParen()
        digest_buffer()
        tokens.push type: "closeParen"
      else if char.isDoubleQuote()
        digest_buffer()
        quote_mode = on
      else
        add_buffer char
  digest_buffer()

  tokens

parseText = (line, args) ->

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