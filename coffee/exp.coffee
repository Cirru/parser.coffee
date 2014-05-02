
{Token} = require './token'

exports.Exp = class
  constructor: (list) ->
    @_list = list

  isExp: yes
  isToken: no

  isEmpty: ->
    @_list.length is 0

  hasChild: ->
    @_list.length > 0

  getFirst: ->
    @_list[0]

  exposeList: ->
    @_list

  resolveDollar: ->
    for node, index in @_list
      if node.isToken
        token = node
        if token.isDollar()
          tokensAfter = @_list.splice (index + 1)
          expAfter = new Exp tokensAfter
          expAfter.resolveDollar()
          @_list.push expAfter
          break

  resolveComma: ->
    lastPlace = @_list.length - 1
    for index in [lastPlace...0]
      node = @_list[index]
      if node.isExp
        exp = node
        if exp.hasChild()
          head = exp.getFirst()
          if head.isToken
            token = head
            if token.isComma()
              exp.resolveComma()
              body = exp.exposeList()[1..]
              @_list.splice index, 1, body...