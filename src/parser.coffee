log = console.log

Array.prototype.__defineGetter__ 'last', -> @[@length - 1]
Array.prototype.__defineSetter__ 'last', (value) ->
  @[@length - 1] = value

str$ = (x) -> typeof x is 'string'
arr$ = Array.isArray
obj$ = (x) -> (not (arr$ x)) and (typeof x is 'object')
num$ = (x) -> not (Number.isNaN x)

{wrap} = require "./wrap"

exports.build = (content) ->
  source = content.split ""

  list = []
  buffer = ""

  while source[0]?
    char = source.shift()
    switch char
      when "(", ")"
        if buffer.length > 0
          list.push buffer
          buffer = ""
        list.push char
      when " ", "\n"
        if buffer.length > 0
          list.push buffer
          buffer = ""
      else
        buffer += char

  # log list

  tree = do cell = ->
    self = []

    while list[0]
      piece = list.shift()

      switch piece
        when "("
          self.push cell()
        when ")"
          return self
        else
          self.push piece
    
    # log piece, self
    self

  tree

exports.parse = (content) ->
  exports.build (wrap content)