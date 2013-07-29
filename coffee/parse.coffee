
fs = require 'fs'
path = require 'path'
{match} = require 'coffee-pattern'

require './rewrite'

parse = (status, ast, text) ->
  match text,
    null, default_token

  default_token = ->

wrap_parse = (filename) ->
  fullpath = path.join process.env.PWD, "./test/#{filename}"
  text = fs.readFileSync fullpath, 'utf8'
  ast =
    filename: filename
    fullpath: fullpath
    tree: parse [], {}, text

exports.parse = wrap_parse