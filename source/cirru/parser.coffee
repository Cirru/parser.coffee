
tree = require './tree'
# lodash = require 'lodash'
# json = require 'cirru-json'

exports.parse = (code, filename) ->
  # window.debugData = []
  buffer = null

  state =
    name: 'indent'
    x: 1
    y: 1
    level: 1 # inside list
    indent: 0
    indented: 0 # counter
    nest: 0 # parentheses
    path: filename
  res = parse [], buffer, state, code
  res = res.map tree.resolveDollar
  res = res.map tree.resolveComma
  # window.debugData = json.generate window.debugData
  res

exports.pare = (code, filename) ->
  res = exports.parse code, filename

  shorten = (xs) ->
    if Array.isArray xs
    then xs.map shorten
    else xs.text

  shorten res

# eof

_escape_eof = (xs, buffer, state, code) ->
  throw new Error "EOF in escape state"

_string_eof = (xs, buffer, state, code) ->
  throw new Error "EOF in string state"

_space_eof = (xs, buffer, state, code) ->
  xs

_token_eof = (xs, buffer, state, code) ->
  buffer.ex = state.x
  buffer.ey = state.y
  xs = tree.appendBuffer xs, state.level, buffer
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
  state.name = 'escape'
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
  if state.nest isnt 0
    throw Error 'incorrect nesting'
  state.name = 'indent'
  state.x = 1
  state.y += 1
  state.indented = 0
  parse xs, buffer, state, code[1..]

_space_open = (xs, buffer, state, code) ->
  nesting = tree.createNesting(1)
  xs = tree.appendList xs, state.level, nesting
  state.nest += 1
  state.level += 1
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_close = (xs, buffer, state, code) ->
  state.nest -= 1
  state.level -= 1
  if state.nest < 0
    throw new Error 'close at space'
  state.x += 1
  parse xs, buffer, state, code[1..]

_space_quote = (xs, buffer, state, code) ->
  state.name = 'string'
  buffer =
    text: ''
    x: state.x
    y: state.y
    path: state.path
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
  buffer.ex = state.x
  buffer.ey = state.y
  xs = tree.appendBuffer xs, state.level, buffer
  state.x += 1
  buffer = null
  parse xs, buffer, state, code[1..]

_token_newline = (xs, buffer, state, code) ->
  state.name = 'indent'
  buffer.ex = state.x
  buffer.ey = state.y
  xs = tree.appendBuffer xs, state.level, buffer
  state.indented = 0
  state.x = 1
  state.y += 1
  buffer = null
  parse xs, buffer, state, code[1..]

_token_open = (xs, buffer, state, code) ->
  throw new Error 'open parenthesis in token'

_token_close = (xs, buffer, state, code) ->
  state.name = 'space'
  buffer.ex = state.x
  buffer.ey = state.y
  xs = tree.appendBuffer xs, state.level, buffer
  buffer = null
  parse xs, buffer, state, code

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
  parse xs, buffer, state, code[1..]

_indent_newilne = (xs, buffer, state, code) ->
  state.x = 1
  state.y += 1
  state.indented = 0
  parse xs, buffer, state, code[1..]

_indent_close = (xs, buffer, state, code) ->
  throw new Error 'close parenthesis at indent'

_indent_else = (xs, buffer, state, code) ->
  state.name = 'space'
  if (state.indented % 2) is 1
    throw new Error 'odd indentation'
  indented = state.indented / 2
  diff = indented - state.indent

  if diff <= 0
    nesting = tree.createNesting 1
    xs = tree.appendList xs, (state.level + diff - 1), nesting
  else if diff > 0
    nesting = tree.createNesting diff
    xs = tree.appendList xs, state.level, nesting

  state.level += diff
  state.indent = indented
  parse xs, buffer, state, code

# parse

parse = (args...) ->
  [xs, buffer, state, code] = args
  scope = {code, xs, buffer, state}
  # window.debugData.push (lodash.cloneDeep scope)
  eof = code.length is 0
  char = code[0]
  switch state.name
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
        else           _string_else       args...
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
        when ')'  then _indent_close      args...
        else           _indent_else       args...
