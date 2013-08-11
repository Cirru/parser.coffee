
fs = require 'fs'
path = require 'path'
{match} = require 'coffee-pattern'
{type, render, stringify} = require './util'
{protos} = require './states'
prettyjson = require 'prettyjson'

parse = (file) ->
  caret = protos.caret.new()
  buffer = protos.buffer.new()
  stack = protos.stack.new()
  indent = protos.indent.new()
  ast = protos.ast.new()
  folding = protos.folding.new()
  brackets = protos.brackets.new()

  pushStack = (object) -> stack.push name: (caret.wrap object)
  clear_buffer = ->
    # if buffer.text? then ast.push buffer.out() # debug mode
    if buffer.text?
      ast.push (caret.wrap text: buffer.out(), file: file)
    if stack.now is 'buffer' then stack.pop()
  put_error = (name) ->
    ast.errors.push error_message (caret.wrap text: name, file: file)
  check_bracket = ->
    if brackets.count > 0
      put_error 'bracket not closed'
    else if brackets.count < 0
      put_error 'too many close bracket'
    brackets.end()

  ast.nest()

  file.text.split('').forEach (char) ->

    normal_pattern = -> match char,
      '"': -> pushStack 'quote'
      ' ': ->
      $: -> # when `$` occurs, fold the code
        ast.nest()
        folding.add (caret.wrap level: indent.level)
      '\n': ->
        clear_buffer()
        pushStack 'indent'
        check_bracket()
      '(': ->
        clear_buffer()
        ast.nest()
        brackets.add()
      ')': ->
        clear_buffer()
        ast.ease()
        brackets.pop()
      undefined, ->
        pushStack 'buffer'
        buffer.add char

    match stack.now,
      empty: normal_pattern
      buffer: -> match char,
        ' ': ->
          clear_buffer()
          stack.pop()
        '\n': ->
          clear_buffer()
          pushStack 'indent'
          check_bracket()
        ')': ->
          clear_buffer()
          ast.ease()
          stack.pop()
          brackets.pop()
        undefined, ->
          buffer.add char
      escape: ->
        buffer.add char
        stack.pop()
      quote: -> match char,
        '\\': -> pushStack 'escape'
        '"': ->
          clear_buffer()
          stack.pop()
        '\n': ->
          put_error 'quote not closed'
          clear_buffer()
          stack.pop()
        undefined, -> buffer.add char
      indent: -> match char,
        ' ': ->
          indent.count()
        '\n': ->
          indent.skip()
        undefined, ->
          step = indent.read()
          do pop_folding = -> # handle `$`, when `$` ends
            if folding.exists and (indent.level <= folding.level)
              out = folding.pop()
              ast.ease()
              pop_folding()
          match step.type,
            indent: ->
              [1..step.step].map -> ast.nest()
            dedent: ->
              [1..step.step].map -> ast.ease()
              ast.newline()
            plain: ->
              ast.newline()
          stack.pop()
          do normal_pattern
    match char,
      '\n': -> caret.newline()
      undefined, -> caret.forward()
  if buffer.text? then clear_buffer()
  while folding.exists
    folding.pop()
    ast.ease()
  if stack.now is 'quote' then put_error 'quote at end'
  check_bracket()
  ast

wrap_parse = (filepath) ->
  text = fs.readFileSync filepath, 'utf8'
  file =
    path: filepath
    text: text

  parse file

repeat = (char, n) ->
  if n > 1 then [1..n].map(-> char).join('')
  else if n is 1 then char
  else ''

error_message = (error) ->
  info = []
  lines = error.file.text.split('\n')
  info.push ''
  info.push "✗ #{error.file.path}: #{error.y + 1}"
  info.push lines[error.y]
  cursor = repeat ' ', error.x
  cursor = cursor[...-1] + '^ ' + error.text
  info.push cursor, ''
  info.join '\n'

exports.parse = wrap_parse
exports.error = error_message