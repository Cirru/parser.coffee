
fs = require 'fs'
path = require 'path'
{match} = require 'coffee-pattern'
{type} = require './util'
{Caret, Buffer, Stack} = require './states'
print = (args...) -> console.log args...

tokenize = (text) ->
  caret = new Caret
  buffer = new Buffer
  stack = new Stack
  tokens = []

  pushStack = (object) -> stack.push (caret.wrap object)
  pushTokens = (object) -> tokens.push (caret.wrap object)

  text.split('').forEach (char) ->
    normal_pattern = -> match char,
      '"': -> pushStack name: 'quote'
      ' ': -> # no state changes
      '\n': -> # no state changes
      '(': ->
        pushStack name: 'bracket'
        pushTokens bracket: 'more'
        match buffer.text?,
          yes, -> pushTokens text: buffer.out()
      undefined, -> 
        pushStack name: 'buffer'
        buffer.add char
    console.log ':::', stack.now, char
    match stack.now,
      empty: normal_pattern
      bracket: normal_pattern
      buffer: -> match char,
        ' ': ->
          pushTokens text: buffer.out()
          stack.pop()
        '\n': ->
          pushTokens text: buffer.out()
          # create indentation
        ')': ->
          pushTokens text: buffer.out()
          pushTokens bracket: 'less'
          stack.pop()
        undefined, ->
          buffer.add char
      escape: -> buffer.add char
      quote: -> match char,
        '\\': -> pushStack name: 'escape'
        '"': ->
          pushTokens text: buffer.out()
          stack.pop()
        undefined, ->
          buffer.add char
    match char,
      '\n': -> caret.newline()
      undefined, -> caret.forward()
  tokens

parse = (tokens) ->
  tokens

wrap_parse = (filename) ->
  fullpath = path.join process.env.PWD, "./test/#{filename}"
  text = fs.readFileSync fullpath, 'utf8'

  path: fullpath
  ast: parse tokenize text

exports.parse = wrap_parse