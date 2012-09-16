
show = console.log
isArr = Array.isArray

esc = '\\'
lef = '('
rig = ')'
sep = ' '
mle = '\u0001'
mri = '\u0002'

maker = (arr) ->
  arr

has_content = (obj) -> obj.line.trim().length > 0

inner = (obj) -> obj.line[..1] is '  '

short = (obj) ->
  obj.line = obj.line[2..]
  obj

fold = (arr) ->
  ret = []

  inner_append = (item) ->
    end = ret.length - 1
    if ret[end]? and (isArr ret[end])
      ret[end].push (short item)
    else ret.push [short item]

  arr.forEach (item) ->
    if inner item then inner_append item
    else ret.push item

  res = []
  ret.forEach (item) ->
    if isArr item then res.push (fold item)
    else res.push item
  res

divide = (arr) ->
  show 'input:::', arr
  ret = []
  arr.forEach (item) ->
    end = ret.length - 1
    if isArr item
      ret.push [] unless isArr ret[end]
      end = ret.length - 1
      (divide item).forEach (x) -> ret[end].push x
    else
      ret.push []
      end += 1
      ret[end].push item
  show 'output:::', ret
  ret

tokenize = (str) ->
  isEsc = no
  token = ''
  list = []
  str.split('').forEach (c) ->
    if isEsc
      token += c
      isEsc = no
    else
      if c is esc
        isEsc = yes
      if c is lef
        list.push token if token.length > 0
        token = ''
        list.push mle
      if c is rig
        list.push token if token.length > 0
        token = ''
        list.push mri
      if c is sep
        list.push token if token.length > 0
        token = 0
  list

magic = (tokens) ->
  len = tokens.length
  pos = 1
  busy = ->
    tree = []
    while pos <= len
      if pos is len then err 'pos reach len'
      c = tokens[pos]
      pos += 1
      if c is '(' then tree.push busy()
      else if c is ')' then return tree
      else tree.push c
  ret = busy()
  ret

exports.parser = (str) ->
  n = 0
  material = []
  transfer = (item) ->
    n += 1
    material.push n: n, line: item
  str.split('\n').forEach(transfer)
  res = material.filter(has_content)
  divide (fold res)