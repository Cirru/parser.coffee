
tree = require './tree'

exports.parse = (code, filename) ->
  buffer = null

  state =
    name: 'newline'
    x: 1
    y: 1
    path: filename
  parse [], buffer, state, code

# eof

_escape_eof = (xs, buffer, state, code) ->
  throw new Error "EOF in escape state"

_string_eof = (xs, buffer, state, code) ->
  throw new Error "EOF in string state"

_space_eof = (xs, buffer, state, code) ->
  xs

_token_eof = (xs, buffer, state, code) ->
  buffer.$x = state.x
  buffer.$y = state.y
  xs = tree.insert xs, state.level, buffer
  buffer = null
  xs

_indent_eof = (xs, buffer, state, code) ->
  xs

# escape

_escape_newline = (xs, buffer, state, code) ->
  throw new Error 'newline while escape'

_escape_n = (xs, buffer, state, code) ->
  state.x += 1
  buffer.text += '\n'
  state.name = 'string'
  parse xs, buffer, state, code[1..]

_escape_t = (xs, buffer, state, code) ->
  state.x += 1
  buffer.text += '\t'
  state.name = 'string'
  parse xs, buffer, state, code[1..]

_escape_else = (xs, buffer, state, code) ->
  state.x += 1
  buffer.text += code[0]
  state.name = 'string'
  parse xs, buffer, state, code[1..]

# string

_string_backslash = (xs, buffer, state, code) ->
  state.x += 1
  parse xs, buffer, state, code[1..]

_string_newline = (xs, buffer, state, code) ->
  throw new Error 'newline in a string'

_string_quote = (xs, buffer, state, code) ->
  state.name = 'token'
  state.x += 1
  parse xs, buffer, state, code[1..]

_string_else = (xs, buffer, state, code) ->
  state.x += 1
  buffer.text += code[0]
  parse xs, buffer, state, code[1..]

# space

_space_space = (xs, buffer, state, code) ->
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_newline = (xs, buffer, state, code) ->
  if state.nesting isnt 0
    throw Error 'incorrect nesting'
  state.name = 'indent'
  state.x = 0
  state.y = 1
  state.indented = 0
  parse xs, buffer, state, code[1..]

_space_open = (xs, buffer, state, code) ->
  state.nesting += 1
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_close = (xs, buffer, state, code) ->
  state.nesting -= 1
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_quote = (xs, buffer, state, code) ->
  state.name = 'string'
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_else = (xs, buffer, state, code) ->
  state.name = 'token'
  buffer =
    text: code[0]
    x: state.x
    y: state.y
    path: state.path
  state.x += 1
  parse xs, buffer, state, code[1..]

# token

_token_space = (xs, buffer, state, code) ->
  state.name = 'space'
  buffer.$x = state.x
  buffer.$y = state.y
  xs = tree.insert xs, state.level, buffer
  state.x += 1
  buffer = null
  parse xs, buffer, state, code[1..]

_token_newline = (xs, buffer, state, code) ->
  state.name = 'indent'
  buffer.$x = state.x
  buffer.$y = state.y
  xs = tree.insert xs, state.level, buffer
  state.indented = 0
  state.x = 1
  state.y += 1
  buffer = null
  parse xs, buffer, state, code[1..]

_token_open = (xs, buffer, state, code) ->
  throw new Error 'open parenthesis in token'

_token_close = (xs, buffer, state, code) ->
  state.name = 'space'
  buffer.$x = state.x
  buffer.$y = state.y
  xs = tree.insert xs, state.level, buffer
  state.x += 1
  buffer = null
  parse xs, buffer, state, code[1..]

_token_quote = (xs, buffer, state, code) ->
  state.name = 'string'
  state.x += 1
  parse xs, buffer, state, code[1..]

_token_else = (xs, buffer, state, code) ->
  buffer.text += code[0]
  state.x += 1
  parse xs, buffer, state, code[1..]

# indent

_indent_space = (xs, buffer, state, code) ->
  state.indented += 1
  state.x += 1
  parse xs, buffer, state, code

_indent_newilne = (xs, buffer, state, code) ->
  state.x = 1
  state.y += 1
  state.indented = 0
  parse xs, buffer, state, code

_indent_quote = (xs, buffer, state, code) ->
  state.name = 'string'
  state = tree.recordIndent state
  state.x += 1
  parse xs, buffer, state, code

_indent_open = (xs, buffer, state, code) ->
  state.name = 'space'
  state = tree.recordIndent state
  state.x += 1
  parse xs, buffer, state, code

_indent_close = (xs, buffer, state, code) ->
  throw new Error 'close parenthesis at indent'

_indent_else = (xs, buffer, state, code) ->
  state.name = 'token'
  buffer =
    text: code[0]
    x: state.x
    y: state.y
    path: state.path
  state.x += 1
  parse xs, buffer, state, code

# parse

parse = (args...) ->
  eof = code.length is 0
  char = code[0]
  [xs, buffer, state, code] = args
  switch state
    when 'escape'
      if eof      then _escape_eof        args...
      else switch char
        when '\n' then _escape_newline    args...
        when 'n'  then _escape_n          args...
        when 't'  then _escape_t          args...
        else           _escape_else       args...
    when 'string'
      if eof      then _string_eof        args...
      else switch char
        when '\\' then _string_backslash  args...
        when '\n' then _string_newline    args...
        when '"'  then _string_quote      args...
        else      then _string_else       args...
    when 'space'
      if eof      then _space_eof         args...
      else switch char
        when ' '  then _space_space       args...
        when '\n' then _space_newline     args...
        when '('  then _space_open        args...
        when ')'  then _space_close       args...
        when '"'  then _space_quote       args...
        else           _space_else        args...
    when 'token'
      if eof      then _token_eof         args...
      else switch char
        when ' '  then _token_space       args...
        when '\n' then _token_newline     args...
        when '('  then _token_open        args...
        when ')'  then _token_close       args...
        when '"'  then _token_quote       args...
        else           _token_else        args...
    when 'indent'
      if eof      then _indent_eof        args...
      else switch char
        when ' '  then _indent_space      args...
        when '\n' then _indent_newilne    args...
        when '"'  then _indent_quote      args...
        when '('  then _indent_open       args...
        when ')'  then _indent_close      args...
        else           _indent_else       args...
