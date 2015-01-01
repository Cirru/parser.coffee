
exports.appendBuffer = appendBuffer = (xs, level, buffer) ->
  if level is 0
    xs.concat [buffer]
  else
    last = xs.length - 1
    res = appendBuffer xs[last], (level - 1), buffer
    xs[...-1].concat [res]

exports.appendList = appendList = (xs, level, list) ->
  if level is 0
    xs.concat [list]
  else
    last = xs.length - 1
    res = appendList xs[last], (level - 1), list
    xs[...-1].concat [res]

exports.createNesting = (n) ->
  create = (xs, n) ->
    if n <= 1
    then xs
    else [create xs, (n - 1)]

  create [], n
