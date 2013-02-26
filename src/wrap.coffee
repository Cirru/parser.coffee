
trimRight = (str) -> str.trimRight()
hasContent = (str) -> str.length > 0
produce = (char, n) -> [0...n].map(-> char).join ""
indents = (line) -> line.match(/^\s*/)[0]
half = (num) -> Math.round (num / 2)
indentOf = (line) -> half indents(line).length
codePart = (line) -> line.trimLeft()

single = /^\s{2,}\S+$/

exports.wrap = (file) ->

  lines = file.split("\n").map(trimRight).filter(hasContent)
  index = lines.map indentOf

  res = []
  cache = 0
  lines.forEach (line, i) ->
    prev = index[i - 1] or 0
    curr = index[i]
    next = index[i + 1] or 0
    
    add_left = 1
    add_right = 1
    if (curr >= prev) and (curr is next)
      if line.match(single)?
        add_left -= 1
        add_right -= 1

    if curr > prev then add_left += (curr - prev - 1)
    if curr > next then add_right += (curr - next)
    else if curr < next then add_right -= 1

    res.push (indents line) +
      (produce "(", add_left) +
      (codePart line) +
      (produce ")", add_right)

  res.join "\n"