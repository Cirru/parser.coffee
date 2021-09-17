
export appendItem = appendItem = (xs, level, buffer) ->
  if level is 0
    xs.concat [buffer]
  else
    last = xs.length - 1
    res = appendItem xs[last], (level - 1), buffer
    xs[...-1].concat [res]

export createNesting = (n) ->
  create = (xs, n) ->
    if n <= 1
    then xs
    else [create xs, (n - 1)]

  create [], n

export resolveDollar = resolveDollar = (xs) ->
  if xs.length is 0 then return xs
  repeat = (before, after) ->
    if after.length is 0 then return before
    cursor = after[0]
    if Array.isArray cursor
      repeat (before.concat [resolveDollar cursor]), after[1..]
    else if cursor.text is '$'
      before.concat [resolveDollar after[1..]]
    else
      repeat (before.concat [cursor]), after[1..]
  repeat [], xs

export resolveComma = resolveComma = (xs) ->
  if xs.length is 0 then return xs
  repeat = (before, after) ->
    if after.length is 0 then return before
    cursor = after[0]
    if (Array.isArray cursor) and (cursor.length > 0)
      head = cursor[0]
      if Array.isArray head
        repeat (before.concat [resolveComma cursor]), after[1..]
      else if head.text is ','
        repeat before, ((resolveComma cursor[1..]).concat after[1..])
      else
        repeat (before.concat [resolveComma cursor]), after[1..]
    else
      repeat (before.concat [cursor]), after[1..]
  repeat [], xs
