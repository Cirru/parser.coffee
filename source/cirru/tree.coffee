
exports.insert = insert = (xs, level, buffer) ->
  if level is 0
    xs.concat buffer
  else
    last = xs.lengh - 1
    xs[...-1].concat (insert xs[last], (level - 1), buffer)

exports.recordIndent = (state) ->
  if (state.indented % 2) is 1
    throw new Error 'odd indentation'
  indented = state.indented / 2
  state.level += (indented - state.indent)
  state.indent = indented
  state
