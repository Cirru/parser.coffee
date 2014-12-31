
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
  xs

_string_eof = (xs, buffer, state, code) ->
  xs

_space_eof = (xs, buffer, state, code) ->
  xs

_token_eof = (xs, buffer, state, code) ->
  xs

_indent_eof = (xs, buffer, state, code) ->
  xs

# escape

_escape_newline = (xs, buffer, state, code) ->
  buffer.token += '\n'
  buffer.$x = 1
  buffer.$y += 1
  state.name = 'string'
  parse xs, buffer, state, code[1..]

_escape_n = (xs, buffer, state, code) ->
  buffer.token += '\n'
  buffer.$x += 1
  state.name = 'string'
  parse xs, buffer, state, code[1..]

_escape_t = (xs, buffer, state, code) ->
  buffer.token += '\t'
  buffer.$x += 1
  state.name = 'string'
  parse xs, buffer, state, code[1..]

_escape_else = (xs, buffer, state, code) ->
  buffer.token += code[0]
  buffer.$x += 1
  state.name = 'string'
  parse xs, buffer, state, code[1..]

# string

_string_backslash = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_string_newline = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_string_quote = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_string_else = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

# space

_space_space = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_space_newline = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_space_open = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_space_close = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_space_quote = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_space_else = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

# token

_token_space = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_token_newline = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_token_open = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_token_close = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_token_quote = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

_token_else = (xs, buffer, state, code) ->
  parse xs, buffer, state, code[1..]

# indent

_indent_space = (xs, buffer, state, code) ->
  parse xs, buffer, state, code

_indent_newilne = (xs, buffer, state, code) ->
  parse xs, buffer, state, code

_indent_quote = (xs, buffer, state, code) ->
  parse xs, buffer, state, code

_indent_open = (xs, buffer, state, code) ->
  parse xs, buffer, state, code

_indent_close = (xs, buffer, state, code) ->
  parse xs, buffer, state, code

_indent_else = (xs, buffer, state, code) ->
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
