
exports.Token = class Token

  constructor: (char) ->
    @_data = {}
    @_text = char.getText()
    @_data.sx = @_data.ex = char.x
    @_data.sy = @_data.ey = char.y

    @isBare = yes

  isExp: no
  isToken: yes

  setStart: (start) ->
    @_data.sx = start.x
    @_data.sy = start.y

  setEnd: (end) ->
    @_data.ex = end.ex
    @_data.ey = end.ey

  add: (text) ->
    @_text += text

  isComma: ->
    @isBare and (@_text is ',')

  isDollar: ->
    @isBare and (@_text is '$')

  isLeftParen: ->
    @isBare and (@_text is '\(')

  isRightParen: ->
    @isBare and (@_text is '\)')

  addChar: (char) ->
    @_text += char.getText()
    @_data.ex = char.x
    @_data.ey = char.y

  getText: ->
    @_text