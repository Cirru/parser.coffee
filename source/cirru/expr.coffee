
{Token} = require './token'

exports.Expr = class Expr

  constructor: (list) ->
    @_list = list

  isExpr: yes
  isToken: no

  isEmpty: ->
    @_list.length is 0

  hasChild: ->
    @_list.length > 0

  getFirst: ->
    @_list[0]

  exposeList: ->
    @_list

  map: (f) ->
    @_list.map f

  resolveDollar: ->
    for node, index in @_list
      if node.isToken
        token = node
        if token.isDollar()
          tokensAfter = @_list.splice index
          exprAfter = new Expr tokensAfter[1..]
          exprAfter.resolveDollar()
          @_list.push exprAfter
          break
      else
        node.resolveDollar()

  resolveComma: ->
    lastPlace = @_list.length - 1
    return if lastPlace < 0
    for index in [lastPlace...0]
      node = @_list[index]
      if node.isExpr
        expr = node
        if expr.hasChild()
          head = expr.getFirst()
          if head.isToken
            token = head
            if token.isComma()
              expr.resolveComma()
              body = expr.exposeList()[1..]
              @_list.splice index, 1, body...
              continue

        node.resolveComma()
