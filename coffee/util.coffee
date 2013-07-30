
exports.type = (x) ->
  Object::toString.call(x)[1...-1].split(' ')[1].toLowerCase()
