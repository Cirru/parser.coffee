
fs = require 'fs'
path = require 'path'
{match} = require 'coffee-pattern'
{List} = require './list'

status = new List ['start']

default_token = (status) -> (char) ->
  match status

parse = (status, ast, text) ->
  match text.head?,
    yes, -> match status.tail.type,
      'block', -> match text.tail,
        '"', ->
      'number', ->
      'keyword', ->
      'string', -> match text.data,
      null, ->
    no, ast

wrap_parse = (filename) ->
  fullpath = path.join process.env.PWD, "./test/#{filename}"
  text = fs.readFileSync fullpath, 'utf8'
  ast =
    filename: filename
    fullpath: fullpath
    tree: parse [], {}, (new List text)

exports.parse = wrap_parse