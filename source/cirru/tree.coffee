
exports.insert = insert = (xs, level, buffer) ->
  if level is 0
    xs[...-1].concat [buffer]
  else
    last = xs.length - 1
    res = insert xs[last], (level - 1), buffer
    # tricky code: prevent list from expanding
    if Array.isArray
    then xs[...-1].concat [res]
    else xs[...-1].concat res

exports.createNesting = (n) ->
  create = (xs, n) ->
    if n <= 1
    then xs
    else [create xs, (n - 1)]

  create [], n
