log = console.log

Array.prototype.__defineGetter__ 'last', -> @[@length-1]
Array.prototype.__defineSetter__ 'last', (value) ->
  @[@length-1] = value

str$ = (x) -> typeof x is 'string'
arr$ = Array.isArray
obj$ = (x) -> (not (arr$ x)) and (typeof x is 'object')
num$ = (x) -> not (Number.isNaN x)

exports.tokenize = tokenize = (line) ->

  raw = line.text

  str = "(#{line.text})"
  res = str
    .replace(/\"/g, '\\"')
    .replace(/\[/g, '[')
    .replace(/\]/g, ']')
    .replace(/([^\(\)\s]+)/g, '"$1",')
    .replace(/\(/g, '[')
    .replace(/\)/g, ']')
    .replace(/\,\s*]/g, ']')
    .replace(/\]\s*\[/g, '],[')
    .replace(/\]\s*\[/g, '],[')
    .replace(/\]\s*\"/g, '],"')
  try
    ret = JSON.parse res
    do sign = (ret) ->
      ret.map (item) ->
        if arr$ item
          item.line = line.n
          sign item
    return ret
  catch err
    log 'Error occured at line #{line.n}:'
    log raw
    log res
    throw err

count = (n) -> Number (n / 2).toFixed()

gen_table = (prev, curr, index) ->
  curr = curr.trimRight()
  n = count curr.match(/^\s*/)[0].length
  line = index + 1
  res = tokenize text: curr.trim(), n: line
  res.line = line
  res.indent = n
  prev.push res
  prev

nest_in = (list, item) ->
  # log 'prev', list
  if item.indent is 0
    delete item.indent
    list.push item
    # log 'list', list
  else
    unless list.last? and (arr$ list.last)
      list.push []
    item.indent -= 1
    nest_in list.last, item

nest_table = (table) ->
  ret = []
  current_line = 0
  table.forEach (line) -> nest_in ret, line
  ret

exports.parse = parse = (content) ->
  lines = content.split '\n'
  table = lines.reduce gen_table, []
  # log 'table', table
  ret =
    code: lines
    tree: nest_table table