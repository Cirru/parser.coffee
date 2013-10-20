
class Charactar
  constructor: (opts) ->
    @text = opts.char
    @x = opts.x
    @y =  opts.y
    @file = opts.file

  isBlank: ->
    @text is " "

  isOpenParen: ->
    @text is "("

  isCloseParen: ->
    @text is ")"
  
  isDollar: ->
    @text is "$"

  isDoubleQuote: ->
    @text is '"'

  isBackslash: ->
    @text is "\\"

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
  file = {text, path: filename}
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
  args = undefined
  if follows.length > 0
    args = parseBlock follows
  
  func = parseText tree[0], args

  func

tokenize = (line) ->
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
      buffer.text += the_char.text
    else
      buffer = char

  until line.isEmpty()
    char = line.shift()
    if quote_mode
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
  tokens = tokenize line
  paren_record = 0
  use_dollar = no
  collection = []
  pointer = collection
  history = []
  dollar_pointer = undefined

  step_in = ->
    new_pointer = []
    pointer.push new_pointer
    history.push pointer
    pointer = new_pointer

  step_out = ->
    pointer = history.pop()

  step_data = (one) ->
    # console.log error a_cursor.buffer
    pointer.push \
      if parse.compact
        one.buffer.text
      else
        one.buffer

  while tokens.length > 0
    cursor = tokens.shift()
    if cursor.type is "string"
      step_data cursor
    else if cursor.type is "text"
      if cursor.buffer.text is "$"
        dollar_pointer = step_in()
        use_dollar = yes
      else
        step_data cursor
    else if cursor.type is "openParen"
      step_in()
      paren_record += 1
    else if cursor.type is "closeParen"
      step_out()
      paren_record -= 1
      if use_dollar
        step_out()
        use_dollar = off

  if use_dollar
    dollar_pointer.push args...
  else
    collection.push args...
  collection

parse = (text, filename) ->
  whole_list = wrap_text text, filename
  parseBlock whole_list

error = (char) ->
  lines = char.file.text.split("\n")
  error_line = lines[char.y]
  hint_line = [1..char.x].map(-> " ").join("") + "^"
  error_line + "\n" + hint_line

# loader for RequireJS, CommonJS and browsers

if define?
  define {parse, error}
else if exports?
  exports.parse = parse
  exports.error = error
else if window?
  window.cirru = {parse, error}