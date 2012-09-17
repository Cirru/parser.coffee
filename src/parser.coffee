
show = console.log
isArr = Array.isArray
err = (info) -> throw new Error info
{inspect} = require 'util'

esc = '\\'
lef = '('
rig = ')'
sep = ' '
mle = 1
mri = 2

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
  # show 'input:::', arr
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
  # show 'output:::', ret
  ret

tokenize = (obj) ->
  str = obj.line
  n = obj.n

  isEsc = no
  count = 0
  token = ''
  list = []
  str.split('').forEach (c) ->
    # show 'c:: ', c
    if isEsc
      token += c
      isEsc = no
    else
      if c is esc
        isEsc = yes
      else if c is lef
        list.push token if token.length > 0
        token = ''
        list.push mle
        count += 1
      else if c is rig
        list.push token if token.length > 0
        token = ''
        list.push mri
        count -= 1
      else if c is sep
        list.push token if token.length > 0
        token = ''
      else
        token += c
  if isEsc
    err "bad ESC at line #{n}: \"#{str}\""
  if count isnt 0
    err "bad parentheses at line #{n}: \"#{str}\""
  if str[0] is ' '
    err "bad space at line #{n}: \"#{str}\""

  list.push token if token.length > 0
  # show 'list:: ', list
  list.unshift mle
  list.push mri
  list.n = n
  list

build = (tokens) ->
  len = tokens.length
  pos = 0
  show 'tokens: ', tokens

  mark = (str) ->
    obj =
      n: tokens.n
      line: str

  busy = ->
    tree = []
    while pos < len
      # if pos is len then err 'pos reach len'
      c = tokens[pos]
      pos += 1
      if c is mle
        tree.push busy()
      else if c is mri
        return tree
      else tree.push (mark c)
    tree
  ret = busy()
  # show 'ret:: ', ret[0]
  show (inspect ret, true, null, true)
  ret[0]

walk = (arr) ->
  ret = []
  arr.forEach (item) ->
    # show 'item: ', item
    if isArr item
      ret.push (walk item)
    else
      (build (tokenize item)).forEach (x) ->
        ret.push x
  # show (inspect ret, true, null, true)
  ret

test1 = ->
  str = "((1 2 (\\(d) ) d (d))"
  n = 0
  obj =
    line: str
    n: n
  show (build (tokenize obj))

exports.parser = (str) ->
  n = 0
  material = []
  transfer = (item) ->
    n += 1
    material.push n: n, line: item
  str.split('\n').forEach(transfer)
  res = material.filter(has_content)
  ret = divide (fold res)
  walk ret