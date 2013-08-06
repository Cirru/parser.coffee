
fs = require 'fs'
path = require 'path'
{match} = require 'coffee-pattern'
{type, render, stringify} = require './util'
{protos} = require './states'
prettyjson = require 'prettyjson'

parse = (text) ->
  caret = protos.caret.new()
  buffer = protos.buffer.new()
  stack = protos.stack.new()
  indent = protos.indent.new()
  ast = protos.ast.new()

  pushStack = (object) -> stack.push (caret.wrap object)
  clear_buffer = ->
    if buffer.text? then ast.push buffer.out()

  ast.nest()

  text.split('').forEach (char) ->

    normal_pattern = -> match char,
      '"': -> pushStack name: 'quote'
      ' ': ->
      '\n': ->
        clear_buffer()
        pushStack name: 'indent'
      '(': ->
        clear_buffer()
        ast.nest()
      undefined, -> 
        pushStack name: 'buffer'
        buffer.add char

    match stack.now,
      empty: normal_pattern
      buffer: -> match char,
        ' ': ->
          clear_buffer()
          stack.pop()
        '\n': ->
          clear_buffer()
          pushStack name: 'indent'
        ')': ->
          clear_buffer()
          ast.ease()
          stack.pop()
        undefined, ->
          buffer.add char
      escape: ->
        buffer.add char
        stack.pop()
      quote: -> match char,
        '\\': -> pushStack name: 'escape'
        '"': ->
          clear_buffer()
          stack.pop()
        '\n': -> throw new Error 'quote not closed'
        undefined, -> buffer.add char
      indent: -> match char,
        ' ': ->
          indent.count()
        '\n': ->
          indent.skip()
        undefined, ->
          step = indent.read()
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
  ast.tree

wrap_parse = (filename) ->
  fullpath = path.join process.env.PWD, "./test/#{filename}"
  text = fs.readFileSync fullpath, 'utf8'

  path: fullpath
  ast: parse text

exports.parse = wrap_parse