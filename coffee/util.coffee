
prettyjson = require 'prettyjson'

exports.type = (x) ->
  Object::toString.call(x)[1...-1].split(' ')[1].toLowerCase()

exports.render = prettyjson.render
exports.stringify = (object) ->
  JSON.stringify object, null, 2
